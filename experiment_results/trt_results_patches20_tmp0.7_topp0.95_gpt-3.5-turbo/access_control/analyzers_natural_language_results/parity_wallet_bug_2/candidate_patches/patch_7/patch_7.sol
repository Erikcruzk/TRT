pragma solidity ^0.4.26;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint required);

    event Deposit(address indexed from, uint value);

    event SingleTransact(
        address indexed owner,
        uint value,
        address indexed to,
        bytes data
    );

    event MultiTransact(
        address indexed owner,
        bytes32 indexed operation,
        uint value,
        address indexed to,
        bytes data
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

    function isOwner(address _addr) public view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool);

    function setDailyLimit(uint _newLimit) external;

    function execute(address _to, uint _value, bytes _data) external returns (bytes32 o_hash);

    function confirm(bytes32 _h) public returns (bool o_success);
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

    mapping (address => uint) public ownerIndex;
    mapping (uint => address) public owners;
    uint public required;
    uint public ownerCount;

    modifier onlyowner() {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) {
            _;
        }
    }

    function() external payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] _owners, uint _required) public {
        require(ownerCount == 0);
        require(_required <= _owners.length);
        require(_owners.length <= MAX_OWNER_COUNT && _owners.length > 0);

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0) && ownerIndex[owner] == 0);
            ownerIndex[owner] = i + 1;
            owners[i + 1] = owner;
        }

        required = _required;
        ownerCount = _owners.length;
        emit RequirementChanged(required);
    }

    function revoke(bytes32 _operation) external {
        uint ownerIndex = ownerIndex[msg.sender];
        require(ownerIndex != 0);
        uint ownerIndexBit = 2 ** ownerIndex;
        var pending = m_pending[_operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_to));
        uint ownerIndex = ownerIndex[_from];
        require(ownerIndex != 0);

        clearPending();
        owners[ownerIndex] = _to;
        ownerIndex[_from] = 0;
        ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_owner));
        require(ownerCount < MAX_OWNER_COUNT);

        clearPending();
        ownerCount++;
        owners[ownerCount] = _owner;
        ownerIndex[_owner] = ownerCount;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        uint ownerIndex = ownerIndex[_owner];
        require(ownerIndex != 0);
        require(required < ownerCount);
        owners[ownerIndex] = address(0);
        ownerIndex[_owner] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint _newRequired) external onlymanyowners(keccak256(msg.data)) {
        require(_newRequired <= ownerCount);
        required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint ownerIndex) external view returns (address) {
        return owners[ownerIndex + 1];
    }

    function isOwner(address _addr) public view returns (bool) {
        return ownerIndex[_addr] > 0;
    }

    function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
        var pending = m_pending[_operation];
        uint ownerIndex = ownerIndex[_owner];

        if (ownerIndex == 0) {
            return false;
        }

        uint ownerIndexBit = 2 ** ownerIndex;
        return !(pending.ownersDone & ownerIndexBit == 0);
    }

    function initDaylimit(uint _limit) external {
        m_dailyLimit = _limit;