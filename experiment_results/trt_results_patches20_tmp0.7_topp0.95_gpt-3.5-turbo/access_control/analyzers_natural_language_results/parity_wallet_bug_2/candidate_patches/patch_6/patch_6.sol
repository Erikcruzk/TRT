pragma solidity ^0.4.9;

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
        address created
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

    function execute(address _to, uint _value, bytes _data) external returns (bytes32 o_hash);

    function confirm(bytes32 _h) external returns (bool o_success);
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

    mapping(address => uint) public m_ownerIndex;
    uint[] public m_owners;
    uint public m_required;

    uint public m_numOwners;

    uint public m_dailyLimit;
    uint public m_spentToday;
    uint public m_lastDay;

    uint constant c_maxOwners = 250;

    mapping(bytes32 => PendingState) public m_pending;
    bytes32[] public m_pendingIndex;

    mapping(bytes32 => Transaction) public m_txs;

    modifier onlyowner() {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        require(confirmAndCheck(_operation));
        _;
    }

    function() public payable {
        if (msg.value > 0) {
            Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] _owners, uint _required) public only_uninitialized {
        require(_owners.length > 0 && _owners.length <= c_maxOwners);
        require(_required > 0 && _required <= _owners.length);

        m_numOwners = _owners.length;
        m_owners.length = m_numOwners;

        for (uint i = 0; i < m_numOwners; i++) {
            address owner = _owners[i];
            require(owner != address(0) && m_ownerIndex[owner] == 0);

            m_owners[i] = uint(owner);
            m_ownerIndex[owner] = i + 1;
        }

        m_required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint ownerIndex = m_ownerIndex[msg.sender];

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

    function changeOwner(address _from, address _to) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_from) && !isOwner(_to));

        uint ownerIndex = m_ownerIndex[_from];

        clearPending();
        m_owners[ownerIndex - 1] = uint(_to);
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        require(_owner != address(0) && !isOwner(_owner));
        clearPending();

        if (m_numOwners >= c_maxOwners) {
            return;
        }

        m_numOwners++;
        m_owners.length = m_numOwners;
        m_owners[m_numOwners - 1] = uint(_owner);
        m_ownerIndex[_owner] = m_numOwners;
        OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        uint ownerIndex = m_ownerIndex[_owner];

        require(isOwner(_owner) && m_required <= m_numOwners - 1 && ownerIndex > 0);

        m_owners[ownerIndex - 1] = 0;
        m_ownerIndex[_owner] = 0;
        clearPending();

        for (uint i = ownerIndex; i < m_numOwners; i++) {
            m_owners[i - 1] = m_owners[i];
            m_ownerIndex[address(m_owners[i])] = i - 1;
        }

        m_numOwners--;
        OwnerRemoved(_owner);
    }

    function changeRequirement(uint _newRequired) external onlymanyowners(keccak256(msg.data)) {
        require(_newRequired