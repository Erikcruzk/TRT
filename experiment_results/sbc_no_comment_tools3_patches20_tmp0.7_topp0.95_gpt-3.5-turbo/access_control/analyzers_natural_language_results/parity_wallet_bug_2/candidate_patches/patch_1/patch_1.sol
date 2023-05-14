pragma solidity ^0.4.24;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint256 newRequirement);

    event Deposit(address indexed from, uint256 value);

    event SingleTransact(
        address indexed owner,
        uint256 value,
        address indexed to,
        bytes data,
        address indexed created
    );

    event MultiTransact(
        address indexed owner,
        bytes32 indexed operation,
        uint256 value,
        address indexed to,
        bytes data,
        address indexed created
    );

    event ConfirmationNeeded(
        bytes32 indexed operation,
        address indexed initiator,
        uint256 value,
        address indexed to,
        bytes data
    );
}

contract WalletAbi {
    function revoke(bytes32 _operation) external;

    function changeOwner(address _from, address _to) external;

    function addOwner(address _owner) external;

    function removeOwner(address _owner) external;

    function changeRequirement(uint256 _newRequired) external;

    function isOwner(address _addr) public view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner)
        public
        view
        returns (bool);

    function setDailyLimit(uint256 _newLimit) external;

    function execute(
        address _to,
        uint256 _value,
        bytes _data
    ) external returns (bytes32 o_hash);

    function confirm(bytes32 _h) public returns (bool o_success);
}

contract WalletLibrary is WalletEvents {
    uint256 constant public MAX_OWNER_COUNT = 250;

    struct PendingState {
        uint256 yetNeeded;
        uint256 ownersDone;
        uint256 index;
    }

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
    }

    uint256 public required;
    uint256 public numOwners;
    uint256 public dailyLimit;
    uint256 public spentToday;
    uint256 public lastDay;

    mapping(uint256 => address) public owners;
    mapping(address => uint256) internal ownerIndex;
    mapping(bytes32 => PendingState) public pending;
    bytes32[] public pendingIndex;
    mapping(bytes32 => Transaction) public transactions;

    modifier onlyOwner() {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlyManyOwners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) {
            _;
        }
    }

    function() public payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] _owners, uint256 _required) internal {
        require(_owners.length > 0 && _required > 0 && _required <= _owners.length && numOwners == 0 && required == 0);
        require(_owners.length <= MAX_OWNER_COUNT);

        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            if (ownerIndex[owner] == 0 && owner != address(0)) {
                ownerIndex[owner] = i + 1;
                owners[i + 1] = owner;
            }
        }

        numOwners = _owners.length;
        required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint256 ownerIndex = ownerIndex[msg.sender];

        if (ownerIndex == 0) {
            return;
        }

        uint256 ownerIndexBit = 2 ** ownerIndex;
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

        uint256 ownerIndex = ownerIndex[_from];

        if (ownerIndex == 0) {
            return;
        }

        clearPending();
        owners[ownerIndex] = _to;
        ownerIndex[_from] = 0;
        ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlyManyOwners(keccak256(msg.data)) {
        if (isOwner(_owner)) {
            return;
        }

        clearPending();

        if (numOwners >= MAX_OWNER_COUNT) {
            return;
        }

        numOwners++;
        owners[numOwners] = _owner;
        ownerIndex[_owner] = numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlyManyOwners(keccak256(msg.data)) {
        uint256 ownerIndex = ownerIndex[_owner];

        if (ownerIndex == 0 || required > numOwners - 1) {
            return;
        }

        owners[ownerIndex] = address(0);
        ownerIndex[_owner] = 0;

        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint256 _newRequired) external onlyManyOwners(keccak256(msg.data)) {
        if (_newRequired > numOwners) {
            return;
        }

        required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint