pragma solidity ^0.4.24;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint newRequirement);

    event Deposit(address indexed _from, uint value);

    event SingleTransact(
        address indexed owner,
        uint value,
        address indexed to,
        bytes data,
        address indexed created
    );

    event MultiTransact(
        address indexed owner,
        bytes32 indexed operation,
        uint value,
        address indexed to,
        bytes data,
        address indexed created
    );

    event ConfirmationNeeded(
        bytes32 indexed operation,
        address indexed initiator,
        uint value,
        address indexed to,
        bytes data
    );
}

contract WalletAbi {
    function revoke(bytes32 _operation) external;

    function changeOwner(address _from, address _to) external;

    function addOwner(address _owner) external;

    function removeOwner(address _owner) external;

    function changeRequirement(uint _newRequired) external;

    function isOwner(address _addr) external view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool);

    function setDailyLimit(uint _newLimit) external;

    function execute(address _to, uint _value, bytes _data) external returns (bytes32);

    function confirm(bytes32 _h) external returns (bool);
}

contract WalletLibrary is WalletEvents {
    struct PendingState {
        uint yetNeeded;
        uint ownersDone;
        uint index;
    }

    struct Transaction {
        address to;
        uint value;
        bytes data;
    }

    uint constant public MAX_OWNER_COUNT = 250;

    uint public required;
    uint public numOwners;

    uint public dailyLimit;
    uint public spentToday;
    uint public lastDay;

    mapping(uint => address) public owners;
    mapping(address => uint) public ownerIndex;
    mapping(bytes32 => PendingState) public pending;
    mapping(bytes32 => Transaction) public transactions;

    modifier onlyOwner {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlyManyOwners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) {
            _;
        }
    }

    constructor(address[] _owners, uint _required, uint _daylimit) public {
        initWallet(_owners, _required, _daylimit);
    }

    function() public payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    function initWallet(address[] _owners, uint _required, uint _daylimit) internal {
        require(_owners.length > 0 && _owners.length <= MAX_OWNER_COUNT && _required > 0 && _required <= _owners.length && _daylimit > 0);
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0) && !isOwner(owner));
            ownerIndex[owner] = numOwners;
            owners[++numOwners] = owner;
        }
        required = _required;
        dailyLimit = _daylimit;
        lastDay = now / 1 days;
    }

    function isOwner(address _addr) public view returns (bool) {
        return ownerIndex[_addr] > 0;
    }

    function revoke(bytes32 _operation) external {
        uint ownerIndex = ownerIndex[msg.sender];
        if (ownerIndex == 0) {
            return;
        }
        uint ownerIndexBit = 2 ** ownerIndex;
        PendingState storage pendingState = pending[_operation];
        if (pendingState.ownersDone & ownerIndexBit > 0) {
            pendingState.yetNeeded++;
            pendingState.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlyManyOwners(keccak256(msg.data)) {
        if (isOwner(_to)) {
            return;
        }
        uint ownerIndex = ownerIndex[_from];
        if (ownerIndex == 0) {
            return;
        }
        owners[ownerIndex] = _to;
        ownerIndex[_from] = 0;
        ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlyManyOwners(keccak256(msg.data)) {
        if (isOwner(_owner)) {
            return;
        }
        if (numOwners >= MAX_OWNER_COUNT) {
            return;
        }
        ownerIndex[_owner] = ++numOwners;
        owners[numOwners] = _owner;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlyManyOwners(keccak256(msg.data)) {
        uint ownerIndex = ownerIndex[_owner];
        if (ownerIndex == 0) {
            return;
        }
        if (required > numOwners - 1) {
            return;
        }
        owners[ownerIndex] = address(0);
        ownerIndex[_owner] = 0;
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint _newRequired) external onlyManyOwners(keccak256(msg.data)) {
        if (_newRequired > numOwners) {
            return;
        }
        required = _newRequired;
        emit RequirementChanged(_newRequired);
    }

    function hasConfirmed(bytes32