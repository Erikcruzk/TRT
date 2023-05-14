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
        address created
    );

    event MultiTransact(
        address indexed owner,
        bytes32 indexed operation,
        uint256 value,
        address indexed to,
        bytes data,
        address created
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
    function revoke(bytes32 _operation) public;

    function changeOwner(address _from, address _to) public;

    function addOwner(address _owner) public;

    function removeOwner(address _owner) public;

    function changeRequirement(uint256 _newRequired) public;

    function isOwner(address _addr) public view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner)
        public
        view
        returns (bool);

    function setDailyLimit(uint256 _newLimit) public;

    function execute(address _to, uint256 _value, bytes _data)
        public
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
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) {
            _;
        }
    }

    function() public payable {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] _owners, uint256 _required) public {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required");

        m_numOwners = _owners.length;

        for (uint256 i = 0; i < _owners.length; ++i) {
            m_owners[i + 1] = _owners[i];
            m_ownerIndex[_owners[i]] = i + 1;
        }

        m_required = _required;
    }

    function revoke(bytes32 _operation) public {
        uint256 ownerIndex = m_ownerIndex[msg.sender];

        require(ownerIndex != 0, "Not an owner");

        uint256 ownerIndexBit = 2**(ownerIndex - 1);
        PendingState storage pending = m_pending[_operation];

        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) public onlymanyowners(sha3(msg.data)) {
        require(isOwner(_to) == false, "New owner already an owner");
        uint256 ownerIndex = m_ownerIndex[_from];

        require(ownerIndex != 0, "Old owner not found");

        clearPending();
        m_owners[ownerIndex] = _to;
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) public onlymanyowners(sha3(msg.data)) {
        require(isOwner(_owner) == false, "Already an owner");
        require(m_numOwners < c_maxOwners, "Max owners reached");

        clearPending();
        m_numOwners++;
        m_owners[m_numOwners] = _owner;
        m_ownerIndex[_owner] = m_numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) public onlymanyowners(sha3(msg.data)) {
        uint256 ownerIndex = m_ownerIndex[_owner];

        require(ownerIndex != 0, "Owner not found");
        require(m_required <= m_numOwners - 1, "Cannot have less than required owners");

        m_owners[ownerIndex] = address(0);
        m_ownerIndex[_owner] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint256 _newRequired) public onlymanyowners(sha3(msg.data)) {
        require(_newRequired > 0 && _newRequired <= m_numOwners, "Invalid required");
        m_required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint256 ownerIndex) public view returns (address) {
        return m_owners[ownerIndex + 1];
    }

    function isOwner(address _addr) public view returns (bool) {
        return m_ownerIndex[_addr] > 0;
    }

    function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
        PendingState storage pending = m_pending[_operation];
        uint256 ownerIndex = m_ownerIndex[_owner];

        if