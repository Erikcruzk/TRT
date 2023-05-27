pragma solidity ^0.4.26;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint256 required);

    event Deposit(address indexed _from, uint256 value);

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
    function revoke(bytes32 _operation) external;

    function changeOwner(address _from, address _to) external;

    function addOwner(address _owner) external;

    function removeOwner(address _owner) external;

    function changeRequirement(uint256 _newRequired) external;

    function isOwner(address _addr) external view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner)
        external
        view
        returns (bool);

    function setDailyLimit(uint256 _newLimit) external;

    function execute(address _to, uint256 _value, bytes _data)
        external
        returns (bytes32 o_hash);

    function confirm(bytes32 _h) public returns (bool o_success);
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
        require(isOwner(msg.sender), "Only owners can perform this action");
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) _;
    }

    function() external payable {
        if (msg.value > 0) Deposit(msg.sender, msg.value);
    }

    function initMultiowned(address[] _owners, uint256 _required)
        internal
        only_uninitialized
    {
        require(
            _owners.length > 0 && _owners.length <= 250,
            "Invalid number of owners"
        );
        require(_required > 0 && _required <= _owners.length, "Invalid required number");

        m_numOwners = _owners.length;
        for (uint256 i = 0; i < _owners.length; ++i) {
            m_owners[i] = _owners[i];
            m_ownerIndex[_owners[i]] = i + 1;
        }
        m_required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint256 ownerIndex = m_ownerIndex[msg.sender];
        require(ownerIndex > 0, "Only owners can perform this action");
        uint256 ownerIndexBit = 2**ownerIndex;
        var pending = m_pending[_operation];
        require(
            pending.ownersDone & ownerIndexBit > 0,
            "This operation has not been confirmed by this owner"
        );
        pending.yetNeeded++;
        pending.ownersDone -= ownerIndexBit;
        emit Revoke(msg.sender, _operation);
    }

    function changeOwner(address _from, address _to)
        external
        onlymanyowners(sha3(msg.data))
    {
        require(isOwner(_to) == false, "New owner is already an owner");
        uint256 ownerIndex = m_ownerIndex[_from];
        require(ownerIndex > 0, "Invalid owner address");
        m_owners[ownerIndex - 1] = _to;
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner)
        external
        onlymanyowners(sha3(msg.data))
    {
        require(isOwner(_owner) == false, "New owner is already an owner");
        require(m_numOwners < 250, "Maximum number of owners reached");
        m_numOwners++;
        m_owners[m_numOwners - 1] = _owner;
        m_ownerIndex[_owner] = m_numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner)
        external
        onlymanyowners(sha3(msg.data))
    {
        uint256 ownerIndex = m_ownerIndex[_owner];
        require(ownerIndex > 0, "Invalid owner address");
        require(m_required <= m_numOwners - 1, "Cannot remove owner as requirement would not be met");

        m_owners[ownerIndex - 1] = address(0);
        m_ownerIndex[_owner] = 0;
        reorganizeOwners();
        m_numOwners--;
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint256 _newRequired)
        external
        onlymanyowners(sha3(msg.data))
    {
        require(_newRequired > 0 && _newRequired <= m_numOwners, "Invalid required number");
        m_required = _newRequired;
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint256 ownerIndex) external view returns (address) {
        return m_owners[ownerIndex];
    }

    function isOwner(address _addr) public view returns (bool) {
        return m_ownerIndex[_addr] > 0;
    }

    function hasConfirmed(bytes32 _operation,