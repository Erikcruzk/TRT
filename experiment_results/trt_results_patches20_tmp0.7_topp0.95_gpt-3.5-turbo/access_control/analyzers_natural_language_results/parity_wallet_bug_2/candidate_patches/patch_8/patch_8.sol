pragma solidity ^0.4.26;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint required);

    event Deposit(address indexed sender, uint value);

    event SingleTransact(address indexed owner, uint value, address indexed to, bytes data);
    event MultiTransact(address indexed owner, bytes32 indexed operation, uint value, address indexed to, bytes data);
    event ConfirmationNeeded(bytes32 indexed operation, address indexed initiator, uint value, address indexed to, bytes data);
}

contract WalletAbi {
    function revoke(bytes32 operation) public;

    function changeOwner(address from, address to) public;

    function addOwner(address owner) public;

    function removeOwner(address owner) public;

    function changeRequirement(uint required) public;

    function isOwner(address owner) public view returns (bool);

    function hasConfirmed(bytes32 operation, address owner) public view returns (bool);

    function setDailyLimit(uint limit) public;

    function execute(address to, uint value, bytes data) public returns (bytes32);

    function confirm(bytes32 h) public returns (bool);
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

    uint constant MAX_OWNER_COUNT = 250;

    modifier onlyowner() {
        require(isOwner(msg.sender), "Only owner can call this function.");
        _;
    }

    modifier onlymanyowners(bytes32 operation) {
        if (confirmAndCheck(operation)) {
            _;
        }
    }

    function() public payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] owners, uint required) internal {
        require(owners.length > 0 && owners.length <= MAX_OWNER_COUNT, "Invalid number of owners.");
        require(required > 0 && required <= owners.length, "Invalid required number.");

        for (uint i = 0; i < owners.length; i++) {
            require(owners[i] != address(0), "Invalid owner address.");
            require(!isOwner(owners[i]), "Duplicate owner address.");
            m_owners[i + 1] = owners[i];
            m_ownerIndex[owners[i]] = i + 1;
        }

        m_numOwners = owners.length;
        m_required = required;
    }

    function revoke(bytes32 operation) external {
        uint ownerIndex = m_ownerIndex[msg.sender];

        if (ownerIndex == 0) {
            return;
        }

        uint ownerIndexBit = 2 ** ownerIndex;
        PendingState storage pending = m_pending[operation];

        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, operation);
        }
    }

    function changeOwner(address from, address to) external onlymanyowners(keccak256(msg.data)) {
        require(to != address(0), "Invalid owner address.");
        uint ownerIndex = m_ownerIndex[from];
        require(ownerIndex > 0, "Invalid owner address.");
        require(!isOwner(to), "Duplicate owner address.");

        clearPending();
        m_owners[ownerIndex] = to;
        m_ownerIndex[from] = 0;
        m_ownerIndex[to] = ownerIndex;
        emit OwnerChanged(from, to);
    }

    function addOwner(address owner) external onlymanyowners(keccak256(msg.data)) {
        require(owner != address(0), "Invalid owner address.");
        require(m_numOwners < MAX_OWNER_COUNT, "Max owners limit reached.");
        require(!isOwner(owner), "Duplicate owner address.");

        clearPending();
        m_numOwners++;
        m_owners[m_numOwners] = owner;
        m_ownerIndex[owner] = m_numOwners;
        emit OwnerAdded(owner);
    }

    function removeOwner(address owner) external onlymanyowners(keccak256(msg.data)) {
        uint ownerIndex = m_ownerIndex[owner];
        require(ownerIndex > 0, "Invalid owner address.");
        require(m_required < m_numOwners, "Required number of owners cannot be less than total owners.");

        m_owners[ownerIndex] = address(0);
        m_ownerIndex[owner] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(owner);
    }

    function changeRequirement(uint required) external onlymanyowners(keccak256(msg.data)) {
        require(required > 0 && required <= m_numOwners, "Invalid required number.");
        m_required = required;
        clearPending();
        emit RequirementChanged(required);
    }

    function getOwner(uint ownerIndex) external view returns (address) {
        return m_owners[ownerIndex + 1];
    }

    function isOwner(address owner) public view returns (bool) {
        return m_ownerIndex[owner] > 0;
    }

    function hasConfirmed(bytes32 operation, address owner) public view returns (bool) {
        uint ownerIndex = m_ownerIndex[owner];
        PendingState storage pending = m_pending[operation];

        if (ownerIndex == 0) {
            return false;
        }

        uint ownerIndexBit = 2 ** ownerIndex;
        return pending.ownersDone & ownerIndexBit > 0;
    }

    function