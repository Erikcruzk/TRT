pragma solidity ^0.4.25;

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

    function isOwner(address _addr) external view returns (bool);

    function hasConfirmed(bytes32 _operation, address _owner)
        external
        view
        returns (bool);

    function setDailyLimit(uint256 _newLimit) external;

    function execute(
        address _to,
        uint256 _value,
        bytes _data
    ) external returns (bytes32 o_hash);

    function confirm(bytes32 _h) external returns (bool o_success);
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
        require(isOwner(msg.sender), "Caller is not an owner");
        _;
    }

    modifier onlymanyowners(bytes32 _operation) {
        if (confirmAndCheck(_operation)) _;
    }

    function() external payable {
        if (msg.value > 0) emit Deposit(msg.sender, msg.value);
    }

    function initMultiowned(address[] _owners, uint256 _required) public {
        require(
            m_numOwners == 0,
            "Contract is already initialized with owners"
        );
        require(
            _owners.length > 0 && _owners.length <= 250,
            "Invalid number of owners"
        );
        require(_required > 0 && _required <= _owners.length, "Invalid requirement");

        m_numOwners = _owners.length;
        m_owners[1] = uint256(msg.sender);
        m_ownerIndex[uint256(msg.sender)] = 1;
        for (uint256 i = 0; i < _owners.length; ++i) {
            m_owners[2 + i] = uint256(_owners[i]);
            m_ownerIndex[uint256(_owners[i])] = 2 + i;
        }
        m_required = _required;
    }

    function revoke(bytes32 _operation) external {
        uint256 ownerIndex = m_ownerIndex[uint256(msg.sender)];

        if (ownerIndex == 0) return;
        uint256 ownerIndexBit = 2**ownerIndex;
        var pending = m_pending[_operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            emit Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_to) == false, "New owner is already an owner");
        uint256 ownerIndex = m_ownerIndex[uint256(_from)];
        require(ownerIndex > 0, "From address is not an owner");

        clearPending();
        m_owners[ownerIndex] = uint256(_to);
        m_ownerIndex[uint256(_from)] = 0;
        m_ownerIndex[uint256(_to)] = ownerIndex;
        emit OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        require(isOwner(_owner) == false, "New owner is already an owner");
        clearPending();
        if (m_numOwners >= 250) {
            reorganizeOwners();
        }
        if (m_numOwners >= 250) {
            return;
        }
        m_numOwners++;
        m_owners[m_numOwners] = uint256(_owner);
        m_ownerIndex[uint256(_owner)] = m_numOwners;
        emit OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(keccak256(msg.data)) {
        uint256 ownerIndex = m_ownerIndex[uint256(_owner)];
        require(ownerIndex > 0, "Address is not an owner");
        require(m_required <= m_numOwners - 1, "Cannot remove owner, requirement not met");

        m_owners[ownerIndex] = 0;
        m_ownerIndex[uint256(_owner)] = 0;
        clearPending();
        reorganizeOwners();
        emit OwnerRemoved(_owner);
    }

    function changeRequirement(uint256 _newRequired) external onlymanyowners(keccak256(msg.data)) {
        require(
            _newRequired > 0 && _newRequired <= m_numOwners,
            "Invalid requirement"
        );
        m_required =