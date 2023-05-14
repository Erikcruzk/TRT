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

    uint constant private MAX_OWNERS = 250;

    mapping(uint => address) private m_owners;
    mapping(address => uint) private m_ownerIndex;
    uint private m_numOwners;
    uint private m_required;

    mapping(bytes32 => PendingState) private m_pending;
    bytes32[] private m_pendingIndex;

    uint private m_dailyLimit;
    uint private m_spentToday;
    uint private m_lastDay;

    mapping(bytes32 => Transaction) private m_txs;

    modifier onlyowner() {
        require(isOwner(msg.sender));
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        require(confirmAndCheck(_operation));
        _;
    }

    function() external payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    constructor() public {
        m_numOwners = 0;
        m_required = 1;
        m_dailyLimit = 0;
        m_spentToday = 0;
        m_lastDay = now;
    }

    function initMultiowned(address[] _owners, uint _required) external only_uninitialized {
        require(_owners.length > 0 && _owners.length <= MAX_OWNERS);
        require(_required > 0 && _required <= _owners.length);

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0));
            require(!isOwner(owner));
            m_numOwners++;
            m_owners[m_numOwners] = owner;
            m_ownerIndex[owner] = m_numOwners;
        }

        m_required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint ownerIndex = m_ownerIndex[msg.sender];
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
        require(isOwner(_from));
        require(!isOwner(_to));
        uint ownerIndex = m_ownerIndex[_from];
        m_owners[ownerIndex] = _to;
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        require(!isOwner(_owner));
        require(m_numOwners < MAX_OWNERS);
        m_numOwners++;
        m_owners[m_numOwners] = _owner;
        m_ownerIndex[_owner] = m_numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        uint ownerIndex = m_ownerIndex[_owner];
        require(isOwner(_owner));
        require(m_required <= m_numOwners - 1);
        m_owners[ownerIndex] = address(0);
        m_ownerIndex[_owner] = 0;
        reorganizeOwners();
        m_numOwners--;
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint _newRequired) external onlymanyowners(keccak256(msg.data)) {
        require(_newRequired > 0 && _newRequired <= m_numOwners);
        m_required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint ownerIndex) external view returns (address) {
        return m_owners[ownerIndex + 1];
    }

    function