pragma solidity ^0.4.24;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint required);

    event Deposit(address indexed sender, uint value);

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
    function revoke(bytes32 operation) external;

    function changeOwner(address from, address to) external;

    function addOwner(address owner) external;

    function removeOwner(address owner) external;

    function changeRequirement(uint newRequired) external;

    function isOwner(address addr) public view returns (bool);

    function hasConfirmed(bytes32 operation, address owner) public view returns (bool);

    function setDailyLimit(uint newLimit) external;

    function execute(address to, uint value, bytes data) external returns (bytes32);

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

    modifier onlyowner() {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlymanyowners(bytes32 operation) {
        require(confirmAndCheck(operation));
        _;
    }

    function() public payable {
        if (msg.value > 0) Deposit(msg.sender, msg.value);
    }

    function initMultiowned(address[] owners, uint required) internal {
        m_numOwners = owners.length + 1;
        m_owners[1] = msg.sender;
        m_ownerIndex[msg.sender] = 1;
        for (uint i = 0; i < owners.length; ++i) {
            m_owners[2 + i] = owners[i];
            m_ownerIndex[owners[i]] = 2 + i;
        }
        m_required = required;
    }

    function revoke(bytes32 operation) external {
        uint ownerIndex = m_ownerIndex[msg.sender];

        if (ownerIndex == 0) return;
        uint ownerIndexBit = 2 ** ownerIndex;
        var pending = m_pending[operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            Revoke(msg.sender, operation);
        }
    }

    function changeOwner(address from, address to) external onlymanyowners(sha3(msg.data)) {
        if (isOwner(to)) return;
        uint ownerIndex = m_ownerIndex[from];
        if (ownerIndex == 0) return;

        clearPending();
        m_owners[ownerIndex] = to;
        m_ownerIndex[from] = 0;
        m_ownerIndex[to] = ownerIndex;
        OwnerChanged(from, to);
    }

    function addOwner(address owner) external onlymanyowners(sha3(msg.data)) {
        if (isOwner(owner)) return;

        clearPending();
        if (m_numOwners >= c_maxOwners) reorganizeOwners();
        if (m_numOwners >= c_maxOwners) return;
        m_numOwners++;
        m_owners[m_numOwners] = owner;
        m_ownerIndex[owner] = m_numOwners;
        OwnerAdded(owner);
    }

    function removeOwner(address owner) external onlymanyowners(sha3(msg.data)) {
        uint ownerIndex = m_ownerIndex[owner];
        if (ownerIndex == 0) return;
        if (m_required > m_numOwners - 1) return;

        m_owners[ownerIndex] = 0;
        m_ownerIndex[owner] = 0;
        clearPending();
        reorganizeOwners();
        OwnerRemoved(owner);
    }

    function changeRequirement(uint newRequired) external onlymanyowners(sha3(msg.data)) {
        if (newRequired > m_numOwners) return;
        m_required = newRequired;
        clearPending();
        RequirementChanged(newRequired);
    }

    function getOwner(uint ownerIndex) external view returns (address) {
        return m_owners[ownerIndex + 1];
    }

    function isOwner(address addr) public view returns (bool) {
        return m_ownerIndex[addr] > 0;
    }

    function hasConfirmed(bytes32 operation, address owner) public view returns (bool) {
        var pending = m_pending[operation];
        uint ownerIndex = m_ownerIndex[owner];

        if (ownerIndex == 0) return false;

        uint ownerIndexBit = 2 ** ownerIndex;
        return !(pending.ownersDone & ownerIndexBit == 0);
    }

    function initDaylimit(uint limit) internal {
        m_dailyLimit = limit;
        m_lastDay = today();
    }

    function setDailyLimit(uint newLimit) external onlymanyowners(sha3(msg.data)) {
        m_dailyLimit = newLimit;
    }

    function resetSpentToday() external onlymanyowners(sha3(msg.data)) {
        m_spentToday = 0;
    }

    modifier only_uninitialized() {
        require(m_numOwners == 0