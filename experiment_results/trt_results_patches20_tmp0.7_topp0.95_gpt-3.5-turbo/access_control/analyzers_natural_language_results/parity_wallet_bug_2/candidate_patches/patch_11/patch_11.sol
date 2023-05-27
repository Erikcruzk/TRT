pragma solidity ^0.4.24;

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
    ) internal {
        require(m_numOwners == 0);
        m_numOwners = _owners.length + 1;
        m_owners[1] = uint(msg.sender);
        m_ownerIndex[uint(msg.sender)] = 1;
        for (uint i = 0; i < _owners.length; ++i) {
            m_owners[2 + i] = uint(_owners[i]);
            m_ownerIndex[uint(_owners[i])] = 2 + i;
        }
        m_required = _required;
    }

    function revoke(bytes32 _operation) public {
        uint ownerIndex = m_ownerIndex[uint(msg.sender)];

        if (ownerIndex == 0) {
            return;
        }
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
        require(isOwner(_to));
        uint ownerIndex = m_ownerIndex[uint(_from)];
        require(ownerIndex > 0);

        clearPending();
        m_owners[ownerIndex] = uint(_to);
        m_ownerIndex[uint(_from)] = 0;
        m_ownerIndex[uint(_to)] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) public onlymanyowners(keccak256(msg.data)) {
        require(!isOwner(_owner));

        clearPending();
        if (m_numOwners >= c_maxOwners) {
            reorganizeOwners();
        }
        if (m_numOwners >= c_maxOwners) {
            return;
        }
        m_numOwners++;
        m_owners[m_numOwners] = uint(_owner);
        m_ownerIndex[uint(_owner)] = m_numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(
        address _owner
    ) public onlymanyowners(keccak256(msg.data)) {
        uint ownerIndex = m_ownerIndex[uint(_owner)];
        require(ownerIndex > 0);
        require(m_required <= m_numOwners - 1);

        m_owners[ownerIndex] = 0;
        m_ownerIndex[uint(_owner)] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(
        uint _newRequired
    ) public onlymanyowners(keccak256(msg.data)) {
        require(_newRequired <= m_numOwners);
        m_required = _newRequired;
        clearPending();
        emit RequirementChanged(_newRequired);
    }

    function getOwner(uint ownerIndex) public view returns (address) {
        return address(m_owners[ownerIndex + 1]);
    }

    function isOwner(address _addr) public view returns (bool) {
        return m_ownerIndex[uint(_addr)] > 0;
    }

    function hasConfirmed(
        bytes32 _operation,
        address _owner
    ) public view returns (bool) {
        var pending = m_pending[_operation];
        uint ownerIndex = m_ownerIndex[uint(_owner