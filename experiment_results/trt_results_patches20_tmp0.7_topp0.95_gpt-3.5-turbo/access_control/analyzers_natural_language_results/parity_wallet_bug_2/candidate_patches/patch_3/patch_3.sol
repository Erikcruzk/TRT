pragma solidity ^0.4.9;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint required);

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

    function isOwner(address _addr) view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner) view returns (bool);

    function setDailyLimit(uint _newLimit) external;

    function execute(address _to, uint _value, bytes _data) external returns (bytes32 o_hash);

    function confirm(bytes32 _h) returns (bool o_success);
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

    uint public constant MAX_OWNERS = 250;
    uint public constant UNINITIALIZED = 0;
    uint public constant NO_DAILY_LIMIT = 0;

    modifier onlyOwner() {
        if (isOwner(msg.sender)) {
            _;
        }
    }

    modifier onlyManyOwners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) {
            _;
        }
    }

    modifier onlyUninitialized() {
        if (m_numOwners > 0) {
            throw;
        }
        _;
    }

    function() payable {
        if (msg.value > 0) {
            Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] _owners, uint _required) onlyUninitialized {
        if (_owners.length > MAX_OWNERS || _required > _owners.length || _required == 0) {
            throw;
        }
        m_numOwners = _owners.length + 1;
        m_owners[1] = uint(msg.sender);
        m_ownerIndex[uint(msg.sender)] = 1;
        for (uint i = 0; i < _owners.length; ++i) {
            m_owners[2 + i] = uint(_owners[i]);
            m_ownerIndex[uint(_owners[i])] = 2 + i;
        }
        m_required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint ownerIndex = m_ownerIndex[uint(msg.sender)];

        if (ownerIndex == 0) {
            return;
        }
        uint ownerIndexBit = 2 ** ownerIndex;
        var pending = m_pending[_operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlyManyOwners(sha3(msg.data)) {
        if (isOwner(_to)) {
            return;
        }
        uint ownerIndex = m_ownerIndex[uint(_from)];
        if (ownerIndex == 0) {
            return;
        }

        clearPending();
        m_owners[ownerIndex] = uint(_to);
        m_ownerIndex[uint(_from)] = 0;
        m_ownerIndex[uint(_to)] = ownerIndex;
        OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlyManyOwners(sha3(msg.data)) {
        if (isOwner(_owner)) {
            return;
        }

        clearPending();
        if (m_numOwners >= MAX_OWNERS) {
            throw;
        }
        m_numOwners++;
        m_owners[m_numOwners] = uint(_owner);
        m_ownerIndex[uint(_owner)] = m_numOwners;
        OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlyManyOwners(sha3(msg.data)) {
        uint ownerIndex = m_ownerIndex[uint(_owner)];
        if (ownerIndex == 0 || m_required > m_numOwners - 1) {
            return;
        }

        m_owners[ownerIndex] = 0;
        m_ownerIndex[uint(_owner)] = 0;
        clearPending();
        reorganizeOwners();
        OwnerRemoved(_owner);
    }

    function changeRequirement(uint _newRequired) external onlyManyOwners(sha3(msg.data)) {
        if (_newRequired > m_numOwners) {
            return;
        }
        m_required = _newRequired;
        clearPending();
        RequirementChanged(_newRequired);
    }

    function getOwner(uint ownerIndex) external view returns (address) {
        return address(m_owners[ownerIndex + 1]);
    }

    function isOwner(address _addr) view returns (bool) {
        return