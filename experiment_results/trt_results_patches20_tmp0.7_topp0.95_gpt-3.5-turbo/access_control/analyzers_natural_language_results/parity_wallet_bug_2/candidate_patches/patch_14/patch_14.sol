pragma solidity ^0.4.26;

contract WalletEvents {
    event Confirmation(address indexed owner, bytes32 indexed operation);
    event Revoke(address indexed owner, bytes32 indexed operation);

    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event OwnerAdded(address indexed newOwner);
    event OwnerRemoved(address indexed oldOwner);

    event RequirementChanged(uint256 newRequirement);

    event Deposit(address indexed _from, uint256 value);

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
    ) external returns (bytes32 o_hash);

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

    function() external payable {
        if (msg.value > 0) {
            Deposit(msg.sender, msg.value);
        }
    }

    function initMultiowned(address[] _owners, uint256 _required) internal {
        require(
            _owners.length > 0 && _owners.length <= 250,
            "Invalid number of owners"
        );
        require(_required > 0 && _required <= _owners.length, "Invalid required");
        m_numOwners = _owners.length;
        m_required = _required;
        m_owners[0] = msg.sender;
        m_ownerIndex[msg.sender] = 0;
        for (uint256 i = 0; i < _owners.length; ++i) {
            require(_owners[i] != address(0), "Invalid owner address");
            require(
                m_ownerIndex[_owners[i]] == 0,
                "Duplicate owner address"
            );
            m_owners[i + 1] = _owners[i];
            m_ownerIndex[_owners[i]] = i + 1;
        }
    }

    function revoke(bytes32 _operation) external onlyowner {
        uint256 ownerIndex = m_ownerIndex[msg.sender];

        if (ownerIndex == 0) {
            return;
        }
        uint256 ownerIndexBit = 2**ownerIndex;
        var pending = m_pending[_operation];
        if (pending.ownersDone & ownerIndexBit > 0) {
            pending.yetNeeded++;
            pending.ownersDone -= ownerIndexBit;
            Revoke(msg.sender, _operation);
        }
    }

    function changeOwner(address _from, address _to) external onlymanyowners(sha3(msg.data)) {
        require(isOwner(_to) == false, "New owner already exists");
        uint256 ownerIndex = m_ownerIndex[_from];
        require(ownerIndex != 0, "Old owner does not exist");

        clearPending();
        m_owners[ownerIndex] = _to;
        m_ownerIndex[_from] = 0;
        m_ownerIndex[_to] = ownerIndex;
        OwnerChanged(_from, _to);
    }

    function addOwner(address _owner) external onlymanyowners(sha3(msg.data)) {
        require(isOwner(_owner) == false, "Owner already exists");
        clearPending();
        require(m_numOwners < 250, "Max owners limit reached");
        m_numOwners++;
        m_owners[m_numOwners] = _owner;
        m_ownerIndex[_owner] = m_numOwners;
        OwnerAdded(_owner);
    }

    function removeOwner(address _owner) external onlymanyowners(sha3(msg.data)) {
        uint256 ownerIndex = m_ownerIndex[_owner];
        require(ownerIndex > 0, "Owner does not exist");
        require(m_required <= m_numOwners - 1, "Cannot have less than required owners");
        if (ownerIndex <= m_numOwners) {
            m_owners[ownerIndex] = m_owners[m_numOwners];
            m_ownerIndex[m_owners[m_numOwners]] = ownerIndex;
            m_owners[m_numOwners] = address(0);
            m_ownerIndex[_owner] = 0;
            m_numOwners--;
            clearPending();
            OwnerRemoved(_owner);
        }
    }

    function changeRequirement(uint256 _newRequired) external onlymanyowners(sha3(msg.data)) {
        require(_newRequired > 0 && _newRequired <= m_numOwners, "Invalid required");
        m_required = _newRequired;