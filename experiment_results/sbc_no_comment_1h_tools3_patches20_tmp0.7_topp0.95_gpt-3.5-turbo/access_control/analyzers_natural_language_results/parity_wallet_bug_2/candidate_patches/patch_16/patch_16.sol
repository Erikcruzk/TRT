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
    function revoke(bytes32 operation) public;

    function changeOwner(address from, address to) public;

    function addOwner(address owner) public;

    function removeOwner(address owner) public;

    function changeRequirement(uint256 newRequired) public;

    function isOwner(address addr) public view returns (bool);

    function hasConfirmed(bytes32 operation, address owner)
        public
        view
        returns (bool);

    function setDailyLimit(uint256 newLimit) public;

    function execute(address to, uint256 value, bytes data)
        public
        returns (bytes32 o_hash);

    function confirm(bytes32 h) public returns (bool o_success);
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

    modifier onlyowner() {
        require(isOwner(msg.sender));
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

    function initMultiowned(address[] owners, uint256 required) public {
        m_numOwners = owners.length + 1;
        m_owners[1] = uint256(msg.sender);
        m_ownerIndex[uint256(msg.sender)] = 1;
        for (uint256 i = 0; i < owners.length; ++i) {
            m_owners[2 + i] = uint256(owners[i]);
            m_ownerIndex[uint256(owners[i])] = 2 + i;
        }
        m_required = required;
    }

    function revoke(bytes32 operation) public {
        uint256 ownerIndex = m_ownerIndex[uint256(msg.sender)];
        if (ownerIndex == 0) return;
        uint256 ownerIndexBit = 2 ** ownerIndex;
        var pending = m_pending[operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, operation);
        }
    }

    function changeOwner(address from, address to) public onlymanyowners(sha3(msg.data)) {
        if (isOwner(to)) return;
        uint256 ownerIndex = m_ownerIndex[uint256(from)];
        if (ownerIndex == 0) return;
        clearPending();
        m_owners[ownerIndex] = uint256(to);
        m_ownerIndex[uint256(from)] = 0;
        m_ownerIndex[uint256(to)] = ownerIndex;
        emit OwnerChanged(from, to);
    }

    function addOwner(address owner) public onlymanyowners(sha3(msg.data)) {
        if (isOwner(owner)) return;
        clearPending();
        if (m_numOwners >= c_maxOwners) reorganizeOwners();
        if (m_numOwners >= c_maxOwners) return;
        m_numOwners++;
        m_owners[m_numOwners] = uint256(owner);
        m_ownerIndex[uint256(owner)] = m_numOwners;
        emit OwnerAdded(owner);
    }

    function removeOwner(address owner) public onlymanyowners(sha3(msg.data)) {
        uint256 ownerIndex = m_ownerIndex[uint256(owner)];
        if (ownerIndex == 0) return;
        if (m_required > m_numOwners - 1) return;
        m_owners[ownerIndex] = 0;
        m_ownerIndex[uint256(owner)] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(owner);
    }

    function changeRequirement(uint256 newRequired) public onlymanyowners(sha3(msg.data)) {
        if (newRequired > m_numOwners) return;
        m_required = newRequired;
        clearPending();
        emit RequirementChanged(newRequired);
    }

    function getOwner(uint256 ownerIndex) public view returns (address) {
        return address(m_owners[ownerIndex + 1]);
    }

    function isOwner(address addr) public view returns (bool) {
        return m_ownerIndex[uint256(addr)] > 0;
    }

    function hasConfirmed(bytes32 operation, address owner)
        public
        view
        returns (bool)
    {
        var pending = m_pending[operation];
        uint256 ownerIndex = m_ownerIndex[uint256(owner)];
        if (ownerIndex == 0) return false;
        uint256 ownerIndexBit = 2 ** ownerIndex;
        return !(pending.ownersDone & ownerIndexBit == 0);