pragma solidity ^0.4.26;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint newRequirement);

    event Deposit(address indexed from, uint value);

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
    function revoke(bytes32 _operation) public;

    function changeOwner(address _from, address _to) public;

    function addOwner(address _owner) public;

    function removeOwner(address _owner) public;

    function changeRequirement(uint _newRequired) public;

    function isOwner(address _addr) public view returns (bool);

    function hasConfirmed(
        bytes32 _operation,
        address _owner
    ) public view returns (bool);

    function setDailyLimit(uint _newLimit) public;

    function execute(
        address _to,
        uint _value,
        bytes _data
    ) public returns (bytes32 o_hash);

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

    uint constant public MAX_OWNERS = 250;

    modifier onlyowner() {
        require(isOwner(msg.sender));
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

    function initMultiowned(
        address[] _owners,
        uint _required
    ) public {
        require(_owners.length > 0 && _owners.length <= MAX_OWNERS);
        require(_required > 0 && _required <= _owners.length);

        m_numOwners = _owners.length;
        m_required = _required;

        for (uint i = 0; i < _owners.length; ++i) {
            require(_owners[i] != address(0));
            require(!isOwner(_owners[i]));
            m_owners[i] = _owners[i];
            m_ownerIndex[_owners[i]] = i;
        }

        m_owners[m_numOwners] = msg.sender;
        m_ownerIndex[msg.sender] = m_numOwners;

        emit OwnerAdded(msg.sender);
    }

    function revoke(bytes32 _operation) public {
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

    function changeOwner(
        address _from,
        address _to
    ) public onlymanyowners(keccak256(msg.data)) {
        require(!isOwner(_to));
        uint ownerIndex = m_ownerIndex[_from];
        require(ownerIndex > 0);

        clearPending();
        m_owners[ownerIndex] = _to;
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) public onlymanyowners(keccak256(msg.data)) {
        require(!isOwner(_owner));
        require(m_numOwners < MAX_OWNERS);

        clearPending();
        m_numOwners++;
        m_owners[m_numOwners] = _owner;
        m_ownerIndex[_owner] = m_numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(
        address _owner
    ) public onlymanyowners(keccak256(msg.data)) {
        uint ownerIndex = m_ownerIndex[_owner];
        require(ownerIndex > 0);
        require(m_required <= m_numOwners - 1);

        m_owners[ownerIndex] = address(0);
        m_ownerIndex[_owner] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(
        uint _newRequired
    ) public onlymanyowners(keccak256(msg.data)) {
        require(_newRequired > 0 && _newRequired <= m_numOwners);
        m_required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint ownerIndex) public view returns (address) {
        return m_owners[ownerIndex];
    }

    function isOwner(address _addr) public view returns (bool) {
        return m_ownerIndex[_addr] > 0;
    }

    function hasConfirmed(
        bytes32 _operation,
        address _owner
    ) public view returns (bool) {
        var pending = m_pending[_operation];
        uint ownerIndex