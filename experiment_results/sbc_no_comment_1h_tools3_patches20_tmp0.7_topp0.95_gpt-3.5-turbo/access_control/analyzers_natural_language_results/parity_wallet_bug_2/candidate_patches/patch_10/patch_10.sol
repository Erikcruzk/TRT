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
    ) public returns (bytes32 o_hash);

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
        require(isOwner(msg.sender), "Only owner is allowed to execute the function");
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) _;
    }

    function() public payable {
        if (msg.value > 0) Deposit(msg.sender, msg.value);
    }

    function initMultiowned(
        address[] _owners,
        uint256 _required
    ) public only_uninitialized {
        require(
            _owners.length > 0 && _required > 0 && _required <= _owners.length,
            "Invalid input"
        );
        m_numOwners = _owners.length;
        for (uint256 i = 0; i < _owners.length; ++i) {
            m_owners[i] = _owners[i];
            m_ownerIndex[_owners[i]] = i + 1;
        }
        m_required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint256 ownerIndex = m_ownerIndex[msg.sender];

        if (ownerIndex == 0) return;
        uint256 ownerIndexBit = 2 ** ownerIndex;
        var pending = m_pending[_operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlymanyowners(
        keccak256(msg.data)
    ) {
        require(isOwner(_to) == false, "New owner is already an owner");
        uint256 ownerIndex = m_ownerIndex[_from];
        require(ownerIndex > 0, "Invalid owner address");

        clearPending();
        m_owners[ownerIndex - 1] = _to;
        delete m_ownerIndex[_from];
        m_ownerIndex[_to] = ownerIndex;
        OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(
        keccak256(msg.data)
    ) {
        require(isOwner(_owner) == false, "New owner is already an owner");

        clearPending();
        require(m_numOwners < c_maxOwners, "Maximum number of owners reached");
        m_numOwners++;
        m_owners[m_numOwners - 1] = _owner;
        m_ownerIndex[_owner] = m_numOwners;
        OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(
        keccak256(msg.data)
    ) {
        uint256 ownerIndex = m_ownerIndex[_owner];
        require(ownerIndex > 0, "Invalid owner address");
        require(m_required < m_numOwners, "Cannot remove owner, required number of owners would be exceeded");

        m_owners[ownerIndex - 1] = 0;
        delete m_ownerIndex[_owner];
        clearPending();
        reorganizeOwners();
        OwnerRemoved(_owner);
    }

    function changeRequirement(uint256 _newRequired) external onlymanyowners(
        keccak256(msg.data)
    ) {
        require(_newRequired > 0 && _newRequired <= m_numOwners, "Invalid required number of owners");
        m_required = _newRequired;
        clearPending();
        RequirementChanged(_newRequired);
    }

    function getOwner(uint256 ownerIndex) external view returns (address) {
        return m_owners[ownerIndex];
    }

    function isOwner(address _addr) public view returns (bool) {
        return m_ownerIndex[_addr] > 0;
    }

    function hasConfirmed(bytes32 _operation, address _owner)
        public
        view
        returns (bool)
    {