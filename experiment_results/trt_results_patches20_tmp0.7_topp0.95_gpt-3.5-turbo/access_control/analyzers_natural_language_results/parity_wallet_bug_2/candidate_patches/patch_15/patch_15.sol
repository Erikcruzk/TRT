pragma solidity ^0.4.24;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint256 required);

    event Deposit(address indexed from, uint256 value);

    event SingleTransact(
        address indexed owner,
        uint256 value,
        address indexed to,
        bytes data
    );

    event MultiTransact(
        address indexed owner,
        bytes32 indexed operation,
        uint256 value,
        address indexed to,
        bytes data
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
    function revoke(bytes32 operation) public;

    function changeOwner(address from, address to) public;

    function addOwner(address owner) public;

    function removeOwner(address owner) public;

    function changeRequirement(uint256 required) public;

    function isOwner(address addr) public view returns (bool);

    function hasConfirmed(bytes32 operation, address owner)
        public
        view
        returns (bool);

    function setDailyLimit(uint256 newLimit) public;

    function execute(address to, uint256 value, bytes data)
        public
        returns (bytes32);

    function confirm(bytes32 h) public returns (bool);
}

contract WalletLibrary is WalletEvents {
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

    modifier onlyOwner() {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlyManyOwners(bytes32 operation) {
        if (confirmAndCheck(operation)) {
            _;
        }
    }

    function() public payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] owners, uint256 required)
        public
        onlyUninitialized
    {
        numOwners = owners.length + 1;
        ownersArray[1] = msg.sender;
        ownerIndex[msg.sender] = 1;
        for (uint256 i = 0; i < owners.length; ++i) {
            ownersArray[2 + i] = owners[i];
            ownerIndex[owners[i]] = 2 + i;
        }
        requiredSignatures = required;
    }

    function revoke(bytes32 operation) public {
        uint256 ownerIndex = ownerIndex[msg.sender];

        if (ownerIndex == 0) return;
        uint256 ownerIndexBit = 2**ownerIndex;
        var pending = pendingTransactions[operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, operation);
        }
    }

    function changeOwner(address from, address to) public onlyManyOwners(sha3(msg.data)) {
        if (isOwner(to)) return;
        uint256 ownerIndex = ownerIndex[from];
        if (ownerIndex == 0) return;

        clearPending();
        ownersArray[ownerIndex] = to;
        ownerIndex[from] = 0;
        ownerIndex[to] = ownerIndex;
        emit OwnerChanged(from, to);
    }

    function addOwner(address owner) public onlyManyOwners(sha3(msg.data)) {
        if (isOwner(owner)) return;

        clearPending();
        if (numOwners >= MAX_OWNERS) reorganizeOwners();
        if (numOwners >= MAX_OWNERS) return;
        numOwners++;
        ownersArray[numOwners] = owner;
        ownerIndex[owner] = numOwners;
        emit OwnerAdded(owner);
    }

    function removeOwner(address owner) public onlyManyOwners(sha3(msg.data)) {
        uint256 ownerIndex = ownerIndex[owner];
        if (ownerIndex == 0) return;
        if (requiredSignatures > numOwners - 1) return;

        ownersArray[ownerIndex] = address(0);
        ownerIndex[owner] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(owner);
    }

    function changeRequirement(uint256 newRequired)
        public
        onlyManyOwners(sha3(msg.data))
    {
        if (newRequired > numOwners) return;
        requiredSignatures = newRequired;
        clearPending();
        emit RequirementChanged(newRequired);
    }

    function getOwner(uint256 ownerIndex) public view returns (address) {
        return ownersArray[ownerIndex + 1];
    }

    function isOwner(address addr) public view returns (bool) {
        return ownerIndex[addr] > 0;
    }

    function hasConfirmed(bytes32 operation, address owner)
        public
        view
        returns (bool)
    {
        var pending = pendingTransactions[operation];
        uint256 ownerIndex = ownerIndex[owner];

        if (ownerIndex == 0) return false;

        uint256 ownerIndexBit = 2**ownerIndex;
        return !(pending.ownersDone & ownerIndexBit == 0);
    }

    function initDaylimit(uint256 limit) public onlyUninitialized {
        dailyLimit = limit;
        lastDay = today();
    }

    function setDailyLimit(uint256 newLimit) public onlyManyOwners(sha3(msg.data)) {
        dailyLimit = newLimit;
    }