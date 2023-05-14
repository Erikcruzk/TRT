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
        address created
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

    modifier onlyowner() {
        require(isOwner(msg.sender), "Sender is not an owner");
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        require(confirmAndCheck(_operation), "Not enough confirmations");
        _;
    }

    function() external payable {
        if (msg.value > 0) Deposit(msg.sender, msg.value);
    }

    function initMultiowned(address[] _owners, uint _required) internal only_uninitialized {
        require(_owners.length > 0 && _required > 0 && _required <= _owners.length, "Invalid input values");

        m_numOwners = _owners.length;
        m_required = _required;
        for (uint i = 0; i < _owners.length; ++i) {
            require(_owners[i] != address(0), "Invalid owner address");
            m_owners[i] = _owners[i];
            m_ownerIndex[_owners[i]] = i;
        }
    }

    function revoke(bytes32 _operation) external {
        uint ownerIndex = m_ownerIndex[msg.sender];

        if (ownerIndex == 0) return;
        uint ownerIndexBit = 2 ** ownerIndex;
        var pending = m_pending[_operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_from), "Invalid owner address");
        require(!isOwner(_to), "New owner already exists");

        clearPending();
        uint ownerIndex = m_ownerIndex[_from];
        m_owners[ownerIndex] = _to;
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        require(!isOwner(_owner), "Owner already exists");
        require(m_numOwners < c_maxOwners, "Maximum number of owners reached");

        clearPending();
        m_numOwners++;
        m_owners[m_numOwners - 1] = _owner;
        m_ownerIndex[_owner] = m_numOwners - 1;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_owner), "Invalid owner address");
        require(m_required < m_numOwners, "Cannot remove owner as minimum required owners reached");

        uint ownerIndex = m_ownerIndex[_owner];
        m_owners[ownerIndex] = address(0);
        m_ownerIndex[_owner] = 0;
        clearPending();
        reorganizeOwners();
        m_numOwners--;
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint _newRequired) external onlymanyowners(keccak256(msg.data)) {
        require(_newRequired > 0 && _newRequired <= m_numOwners, "Invalid input value");
        m_required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint ownerIndex) external view returns (address) {
        return m_owners[ownerIndex];
    }

    function isOwner(address _addr) external view returns (bool) {
        return m_ownerIndex[_addr] > 0;
    }

    function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool) {
        var pending = m_pending[_operation];
        uint ownerIndex = m_ownerIndex[_owner];

        if (ownerIndex == 0) return false;

        uint ownerIndexBit = 2 ** ownerIndex;