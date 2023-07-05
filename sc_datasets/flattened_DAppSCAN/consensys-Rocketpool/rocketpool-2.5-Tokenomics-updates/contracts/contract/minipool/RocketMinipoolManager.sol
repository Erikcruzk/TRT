// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/RocketStorageInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketStorageInterface {

    // Getters
    function getAddress(bytes32 _key) external view returns (address);
    function getUint(bytes32 _key) external view returns (uint);
    function getString(bytes32 _key) external view returns (string memory);
    function getBytes(bytes32 _key) external view returns (bytes memory);
    function getBool(bytes32 _key) external view returns (bool);
    function getInt(bytes32 _key) external view returns (int);
    function getBytes32(bytes32 _key) external view returns (bytes32);

    // Setters
    function setAddress(bytes32 _key, address _value) external;
    function setUint(bytes32 _key, uint _value) external;
    function setString(bytes32 _key, string calldata _value) external;
    function setBytes(bytes32 _key, bytes calldata _value) external;
    function setBool(bytes32 _key, bool _value) external;
    function setInt(bytes32 _key, int _value) external;
    function setBytes32(bytes32 _key, bytes32 _value) external;

    // Deleters
    function deleteAddress(bytes32 _key) external;
    function deleteUint(bytes32 _key) external;
    function deleteString(bytes32 _key) external;
    function deleteBytes(bytes32 _key) external;
    function deleteBool(bytes32 _key) external;
    function deleteInt(bytes32 _key) external;
    function deleteBytes32(bytes32 _key) external;

}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/RocketBase.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

/// @title Base settings / modifiers for each contract in Rocket Pool
/// @author David Rugendyke

abstract contract RocketBase {


    // Version of the contract
    uint8 public version;

    // The main storage contract where primary persistant storage is maintained
    RocketStorageInterface rocketStorage = RocketStorageInterface(0);


    /*** Modifiers **********************************************************/

    /**
    * @dev Throws if called by any sender that doesn't match a Rocket Pool network contract
    */
    modifier onlyLatestNetworkContract() {
        require(getBool(keccak256(abi.encodePacked("contract.exists", msg.sender))), "Invalid or outdated network contract");
        _;
    }

    /**
    * @dev Throws if called by any sender that doesn't match one of the supplied contract or is the latest version of that contract
    */
    modifier onlyLatestContract(string memory _contractName, address _contractAddress) {
        require(_contractAddress == getAddress(keccak256(abi.encodePacked("contract.address", _contractName))), "Invalid or outdated contract");
        _;
    }

    /**
    * @dev Throws if called by any sender that isn't a registered node
    */
    modifier onlyRegisteredNode(address _nodeAddress) {
        require(getBool(keccak256(abi.encodePacked("node.exists", _nodeAddress))), "Invalid node");
        _;
    }

    /**
    * @dev Throws if called by any sender that isn't a trusted node DAO member
    */
    modifier onlyTrustedNode(address _nodeAddress) {
        require(getBool(keccak256(abi.encodePacked("dao.trustednodes", "member", _nodeAddress))), "Invalid trusted node");
        _;
    }

    /**
    * @dev Throws if called by any sender that isn't a registered minipool
    */
    modifier onlyRegisteredMinipool(address _minipoolAddress) {
        require(getBool(keccak256(abi.encodePacked("minipool.exists", _minipoolAddress))), "Invalid minipool");
        _;
    }
    

    /**
    * @dev Throws if called by any account other than a guardian account (temporary account allowed access to settings before DAO is fully enabled)
    */
    modifier onlyGuardian() {
        require(getBool(keccak256(abi.encodePacked("access.role", "guardian", msg.sender))), "Account is not a temporary guardian");
        _;
    }




    /*** Methods **********************************************************/

    /// @dev Set the main Rocket Storage address
    constructor(address _rocketStorageAddress) {
        // Update the contract address
        rocketStorage = RocketStorageInterface(_rocketStorageAddress);
    }


    /// @dev Get the address of a network contract by name
    function getContractAddress(string memory _contractName) internal view returns (address) {
        // Get the current contract address
        address contractAddress = getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
        // Check it
        require(contractAddress != address(0x0), "Contract not found");
        // Return
        return contractAddress;
    }


    /// @dev Get the name of a network contract by address
    function getContractName(address _contractAddress) internal view returns (string memory) {
        // Get the contract name
        string memory contractName = getString(keccak256(abi.encodePacked("contract.name", _contractAddress)));
        // Check it
        require(keccak256(abi.encodePacked(contractName)) != keccak256(abi.encodePacked("")), "Contract not found");
        // Return
        return contractName;
    }

    /// @dev Get revert error message from a .call method
    function getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
        // If the _res length is less than 68, then the transaction failed silently (without a revert message)
        if (_returnData.length < 68) return 'Transaction reverted silently';
        assembly {
            // Slice the sighash.
            _returnData := add(_returnData, 0x04)
        }
        return abi.decode(_returnData, (string)); // All that remains is the revert string
    }



    /*** Rocket Storage Methods ****************************************/

    // Note: Unused helpers have been removed to keep contract sizes down

    /// @dev Storage get methods
    function getAddress(bytes32 _key) internal view returns (address) { return rocketStorage.getAddress(_key); }
    function getUint(bytes32 _key) internal view returns (uint) { return rocketStorage.getUint(_key); }
    function getString(bytes32 _key) internal view returns (string memory) { return rocketStorage.getString(_key); }
    function getBytes(bytes32 _key) internal view returns (bytes memory) { return rocketStorage.getBytes(_key); }
    function getBool(bytes32 _key) internal view returns (bool) { return rocketStorage.getBool(_key); }
    function getInt(bytes32 _key) internal view returns (int) { return rocketStorage.getInt(_key); }
    function getBytes32(bytes32 _key) internal view returns (bytes32) { return rocketStorage.getBytes32(_key); }
    function getAddressS(string memory _key) internal view returns (address) { return rocketStorage.getAddress(keccak256(abi.encodePacked(_key))); }
    function getUintS(string memory _key) internal view returns (uint) { return rocketStorage.getUint(keccak256(abi.encodePacked(_key))); }
    function getBytesS(string memory _key) internal view returns (bytes memory) { return rocketStorage.getBytes(keccak256(abi.encodePacked(_key))); }
    function getBoolS(string memory _key) internal view returns (bool) { return rocketStorage.getBool(keccak256(abi.encodePacked(_key))); }


    /// @dev Storage set methods
    function setAddress(bytes32 _key, address _value) internal { rocketStorage.setAddress(_key, _value); }
    function setUint(bytes32 _key, uint _value) internal { rocketStorage.setUint(_key, _value); }
    function setString(bytes32 _key, string memory _value) internal { rocketStorage.setString(_key, _value); }
    function setBytes(bytes32 _key, bytes memory _value) internal { rocketStorage.setBytes(_key, _value); }
    function setBool(bytes32 _key, bool _value) internal { rocketStorage.setBool(_key, _value); }
    function setInt(bytes32 _key, int _value) internal { rocketStorage.setInt(_key, _value); }
    function setBytes32(bytes32 _key, bytes32 _value) internal { rocketStorage.setBytes32(_key, _value); }
    function setAddressS(string memory _key, address _value) internal { rocketStorage.setAddress(keccak256(abi.encodePacked(_key)), _value); }
    function setUintS(string memory _key, uint _value) internal { rocketStorage.setUint(keccak256(abi.encodePacked(_key)), _value); }
    function setBytesS(string memory _key, bytes memory _value) internal { rocketStorage.setBytes(keccak256(abi.encodePacked(_key)), _value); }
    function setBoolS(string memory _key, bool _value) internal { rocketStorage.setBool(keccak256(abi.encodePacked(_key)), _value); }

    /// @dev Storage delete methods
    function deleteAddress(bytes32 _key) internal { rocketStorage.deleteAddress(_key); }
    function deleteUint(bytes32 _key) internal { rocketStorage.deleteUint(_key); }
    function deleteString(bytes32 _key) internal { rocketStorage.deleteString(_key); }
    function deleteBytes(bytes32 _key) internal { rocketStorage.deleteBytes(_key); }
    function deleteBool(bytes32 _key) internal { rocketStorage.deleteBool(_key); }
    function deleteInt(bytes32 _key) internal { rocketStorage.deleteInt(_key); }
    function deleteBytes32(bytes32 _key) internal { rocketStorage.deleteBytes32(_key); }


}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/node/RocketDAONodeTrustedInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAONodeTrustedInterface {
    function getBootstrapModeDisabled() external view returns (bool);
    function getMemberQuorumVotesRequired() external view returns (uint256);
    function getMemberAt(uint256 _index) external view returns (address);
    function getMemberCount() external view returns (uint256);
    function getMemberMinRequired() external view returns (uint256);
    function getMemberIsValid(address _nodeAddress) external view returns (bool);
    function getMemberLastProposalBlock(address _nodeAddress) external view returns (uint256);
    function getMemberID(address _nodeAddress) external view returns (string memory);
    function getMemberEmail(address _nodeAddress) external view returns (string memory);
    function getMemberJoinedBlock(address _nodeAddress) external view returns (uint256);
    function getMemberProposalExecutedBlock(string memory _proposalType, address _nodeAddress) external view returns (uint256);
    function getMemberReplacedAddress(string memory _type, address _nodeAddress) external view returns (address);
    function getMemberRPLBondAmount(address _nodeAddress) external view returns (uint256);
    function getMemberIsChallenged(address _nodeAddress) external view returns (bool);
    function getMemberUnbondedValidatorCount(address _nodeAddress) external view returns (uint256);
    function incrementMemberUnbondedValidatorCount(address _nodeAddress) external;
    function decrementMemberUnbondedValidatorCount(address _nodeAddress) external;
    function bootstrapMember(string memory _id, string memory _email, address _nodeAddress) external;
    function bootstrapSettingUint(string memory _settingContractName, string memory _settingPath, uint256 _value) external;
    function bootstrapSettingBool(string memory _settingContractName, string memory _settingPath, bool _value) external;
    function bootstrapUpgrade(string memory _type, string memory _name, string memory _contractAbi, address _contractAddress) external;
    function bootstrapDisable(bool _confirmDisableBootstrapMode) external;
    function memberJoinRequired(string memory _id, string memory _email) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/types/MinipoolDeposit.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

// Represents the type of deposits required by a minipool

enum MinipoolDeposit {
    None,    // Marks an invalid deposit type
    Full,    // The minipool requires 32 ETH from the node operator, 16 ETH of which will be refinanced from user deposits
    Half,    // The minipool required 16 ETH from the node operator to be matched with 16 ETH from user deposits
    Empty    // The minipool requires 0 ETH from the node operator to be matched with 32 ETH from user deposits (trusted nodes only)
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/types/MinipoolStatus.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

// Represents a minipool's status within the network

enum MinipoolStatus {
    Initialized,    // The minipool has been initialized and is awaiting a deposit of user ETH
    Prelaunch,      // The minipool has enough ETH to begin staking and is awaiting launch by the node operator
    Staking,        // The minipool is currently staking
    Withdrawable,   // The minipool has become withdrawable on the beacon chain and can be withdrawn from by the node operator
    Dissolved       // The minipool has been dissolved and its user deposited ETH has been returned to the deposit pool
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/minipool/RocketMinipoolInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only


interface RocketMinipoolInterface {
    function getStatus() external view returns (MinipoolStatus);
    function getStatusBlock() external view returns (uint256);
    function getStatusTime() external view returns (uint256);
    function getDepositType() external view returns (MinipoolDeposit);
    function getNodeAddress() external view returns (address);
    function getNodeFee() external view returns (uint256);
    function getNodeDepositBalance() external view returns (uint256);
    function getNodeRefundBalance() external view returns (uint256);
    function getNodeDepositAssigned() external view returns (bool);
    function getNodeWithdrawn() external view returns (bool);
    function getUserDepositBalance() external view returns (uint256);
    function getUserDepositAssigned() external view returns (bool);
    function getUserDepositAssignedTime() external view returns (uint256);
    function getStakingStartBalance() external view returns (uint256);
    function getStakingEndBalance() external view returns (uint256);
    function getValidatorBalanceWithdrawn() external view returns (bool);
    function getWithdrawalCredentials() external view returns (bytes memory);
    function nodeDeposit() external payable;
    function userDeposit() external payable;
    function payout() payable external;
    function refund() external;
    function stake(bytes calldata _validatorPubkey, bytes calldata _validatorSignature, bytes32 _depositDataRoot) external;
    function setWithdrawable(uint256 _stakingStartBalance, uint256 _stakingEndBalance) external;
    function withdraw() external;
    function dissolve() external;
    function close() external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/minipool/RocketMinipoolFactoryInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketMinipoolFactoryInterface {
    function createMinipool(address _nodeAddress, MinipoolDeposit _depositType) external returns (address);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/minipool/RocketMinipoolManagerInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketMinipoolManagerInterface {
    function getMinipoolCount() external view returns (uint256);
    function getMinipoolAt(uint256 _index) external view returns (address);
    function getNodeMinipoolCount(address _nodeAddress) external view returns (uint256);
    function getNodeMinipoolAt(address _nodeAddress, uint256 _index) external view returns (address);
    function getNodeValidatingMinipoolCount(address _nodeAddress) external view returns (uint256);
    function getNodeValidatingMinipoolAt(address _nodeAddress, uint256 _index) external view returns (address);
    function getMinipoolByPubkey(bytes calldata _pubkey) external view returns (address);
    function getMinipoolExists(address _minipoolAddress) external view returns (bool);
    function getMinipoolPubkey(address _minipoolAddress) external view returns (bytes memory);
    function getMinipoolWithdrawalTotalBalance(address _minipoolAddress) external view returns (uint256);
    function getMinipoolWithdrawalNodeBalance(address _minipoolAddress) external view returns (uint256);
    function getMinipoolWithdrawable(address _minipoolAddress) external view returns (bool);
    function getMinipoolWithdrawalProcessed(address _minipoolAddress) external view returns (bool);
    function createMinipool(address _nodeAddress, MinipoolDeposit _depositType) external returns (address);
    function destroyMinipool() external;
    function setMinipoolPubkey(bytes calldata _pubkey) external;
    function setMinipoolWithdrawalBalances(address _minipoolAddress, uint256 _total, uint256 _node) external;
    function setMinipoolWithdrawalProcessed(address _minipoolAddress) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/minipool/RocketMinipoolQueueInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketMinipoolQueueInterface {
    function getTotalLength() external view returns (uint256);
    function getLength(MinipoolDeposit _depositType) external view returns (uint256);
    function getTotalCapacity() external view returns (uint256);
    function getEffectiveCapacity() external view returns (uint256);
    function getNextCapacity() external view returns (uint256);
    function enqueueMinipool(MinipoolDeposit _depositType, address _minipool) external;
    function dequeueMinipool() external returns (address minipoolAddress);
    function removeMinipool() external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/node/RocketNodeStakingInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketNodeStakingInterface {
    function getTotalRPLStake() external view returns (uint256);
    function getNodeRPLStake(address _nodeAddress) external view returns (uint256);
    function getNodeRPLStakedBlock(address _nodeAddress) external view returns (uint256);
    function getTotalEffectiveRPLStake() external view returns (uint256);
    function getNodeEffectiveRPLStake(address _nodeAddress) external view returns (uint256);
    function getNodeMinimumRPLStake(address _nodeAddress) external view returns (uint256);
    function getNodeMinipoolLimit(address _nodeAddress) external view returns (uint256);
    function stakeRPL(uint256 _amount) external;
    function withdrawRPL(uint256 _amount) external;
    function slashRPL(address _nodeAddress, uint256 _ethSlashAmount) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/util/AddressSetStorageInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface AddressSetStorageInterface {
    function getCount(bytes32 _key) external view returns (uint);
    function getItem(bytes32 _key, uint _index) external view returns (address);
    function getIndexOf(bytes32 _key, address _value) external view returns (int);
    function addItem(bytes32 _key, address _value) external;
    function removeItem(bytes32 _key, address _value) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/minipool/RocketMinipoolManager.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only









// Minipool creation, removal and management

contract RocketMinipoolManager is RocketBase, RocketMinipoolManagerInterface {

    // Events
    event MinipoolCreated(address indexed minipool, address indexed node, uint256 time);
    event MinipoolDestroyed(address indexed minipool, address indexed node, uint256 time);

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) {
        version = 1;
    }

    // Get the number of minipools in the network
    function getMinipoolCount() override public view returns (uint256) {
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        return addressSetStorage.getCount(keccak256(abi.encodePacked("minipools.index")));
    }

    // Get a network minipool address by index
    function getMinipoolAt(uint256 _index) override public view returns (address) {
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        return addressSetStorage.getItem(keccak256(abi.encodePacked("minipools.index")), _index);
    }

    // Get the number of minipools owned by a node
    function getNodeMinipoolCount(address _nodeAddress) override public view returns (uint256) {
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        return addressSetStorage.getCount(keccak256(abi.encodePacked("node.minipools.index", _nodeAddress)));
    }

    // Get a node minipool address by index
    function getNodeMinipoolAt(address _nodeAddress, uint256 _index) override public view returns (address) {
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        return addressSetStorage.getItem(keccak256(abi.encodePacked("node.minipools.index", _nodeAddress)), _index);
    }

    // Get the number of validating minipools owned by a node
    function getNodeValidatingMinipoolCount(address _nodeAddress) override public view returns (uint256) {
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        return addressSetStorage.getCount(keccak256(abi.encodePacked("node.minipools.validating.index", _nodeAddress)));
    }

    // Get a validating node minipool address by index
    function getNodeValidatingMinipoolAt(address _nodeAddress, uint256 _index) override public view returns (address) {
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        return addressSetStorage.getItem(keccak256(abi.encodePacked("node.minipools.validating.index", _nodeAddress)), _index);
    }

    // Get a minipool address by validator pubkey
    function getMinipoolByPubkey(bytes memory _pubkey) override public view returns (address) {
        return getAddress(keccak256(abi.encodePacked("validator.minipool", _pubkey)));
    }

    // Check whether a minipool exists
    function getMinipoolExists(address _minipoolAddress) override public view returns (bool) {
        return getBool(keccak256(abi.encodePacked("minipool.exists", _minipoolAddress)));
    }

    // Get a minipool's validator pubkey
    function getMinipoolPubkey(address _minipoolAddress) override public view returns (bytes memory) {
        return getBytes(keccak256(abi.encodePacked("minipool.pubkey", _minipoolAddress)));
    }

    // Get a minipool's total balance at withdrawal
    function getMinipoolWithdrawalTotalBalance(address _minipoolAddress) override public view returns (uint256) {
        return getUint(keccak256(abi.encodePacked("minipool.withdrawal.balance.total", _minipoolAddress)));
    }

    // Get a minipool's node balance at withdrawal
    function getMinipoolWithdrawalNodeBalance(address _minipoolAddress) override public view returns (uint256) {
        return getUint(keccak256(abi.encodePacked("minipool.withdrawal.balance.node", _minipoolAddress)));
    }

    // Get a minipool's withdrawable status
    function getMinipoolWithdrawable(address _minipoolAddress) override public view returns (bool) {
        return getBool(keccak256(abi.encodePacked("minipool.withdrawable", _minipoolAddress)));
    }

    // Get a minipool's withdrawal processed status
    function getMinipoolWithdrawalProcessed(address _minipoolAddress) override public view returns (bool) {
        return getBool(keccak256(abi.encodePacked("minipool.withdrawal.processed", _minipoolAddress)));
    }

    // Create a minipool
    // Only accepts calls from the RocketNodeDeposit contract
    function createMinipool(address _nodeAddress, MinipoolDeposit _depositType) override external onlyLatestContract("rocketMinipoolManager", address(this)) onlyLatestContract("rocketNodeDeposit", msg.sender) returns (address) {
        // Load contracts
        RocketDAONodeTrustedInterface rocketDAONodeTrusted = RocketDAONodeTrustedInterface(getContractAddress("rocketDAONodeTrusted"));
        RocketMinipoolFactoryInterface rocketMinipoolFactory = RocketMinipoolFactoryInterface(getContractAddress("rocketMinipoolFactory"));
        RocketMinipoolQueueInterface rocketMinipoolQueue = RocketMinipoolQueueInterface(getContractAddress("rocketMinipoolQueue"));
        RocketNodeStakingInterface rocketNodeStaking = RocketNodeStakingInterface(getContractAddress("rocketNodeStaking"));
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        // Check node minipool limit based on RPL stake
        require(
            addressSetStorage.getCount(keccak256(abi.encodePacked("node.minipools.index", _nodeAddress))) < rocketNodeStaking.getNodeMinipoolLimit(_nodeAddress),
            "Minipool count after deposit exceeds limit based on node RPL stake"
        );
        // Create minipool contract
        address contractAddress = rocketMinipoolFactory.createMinipool(_nodeAddress, _depositType);
        // Initialize minipool data
        setBool(keccak256(abi.encodePacked("minipool.exists", contractAddress)), true);
        // Add minipool to indexes
        addressSetStorage.addItem(keccak256(abi.encodePacked("minipools.index")), contractAddress);
        addressSetStorage.addItem(keccak256(abi.encodePacked("node.minipools.index", _nodeAddress)), contractAddress);
        // Update unbonded validator count if minipool is unbonded
        if (_depositType == MinipoolDeposit.Empty) { rocketDAONodeTrusted.incrementMemberUnbondedValidatorCount(_nodeAddress); }
        // Emit minipool created event
        emit MinipoolCreated(contractAddress, _nodeAddress, block.timestamp);
        // Add minipool to queue
        rocketMinipoolQueue.enqueueMinipool(_depositType, contractAddress);
        // Return created minipool address
        return contractAddress;
    }

    // Destroy a minipool
    // Only accepts calls from registered minipools
    function destroyMinipool() override external onlyLatestContract("rocketMinipoolManager", address(this)) onlyRegisteredMinipool(msg.sender) {
        // Load contracts
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        RocketDAONodeTrustedInterface rocketDAONodeTrusted = RocketDAONodeTrustedInterface(getContractAddress("rocketDAONodeTrusted"));
        // Initialize minipool & get properties
        RocketMinipoolInterface minipool = RocketMinipoolInterface(msg.sender);
        address nodeAddress = minipool.getNodeAddress();
        // Update minipool data
        setBool(keccak256(abi.encodePacked("minipool.exists", msg.sender)), false);
        // Remove minipool from indexes
        addressSetStorage.removeItem(keccak256(abi.encodePacked("minipools.index")), msg.sender);
        addressSetStorage.removeItem(keccak256(abi.encodePacked("node.minipools.index", nodeAddress)), msg.sender);
        // Update unbonded validator count if minipool is unbonded
        if (minipool.getDepositType() == MinipoolDeposit.Empty) { rocketDAONodeTrusted.decrementMemberUnbondedValidatorCount(nodeAddress); }
        // Emit minipool destroyed event
        emit MinipoolDestroyed(msg.sender, nodeAddress, block.timestamp);
    }

    // Set a minipool's validator pubkey
    // Only accepts calls from registered minipools
    function setMinipoolPubkey(bytes calldata _pubkey) override external onlyLatestContract("rocketMinipoolManager", address(this)) onlyRegisteredMinipool(msg.sender) {
        // Load contracts
        AddressSetStorageInterface addressSetStorage = AddressSetStorageInterface(getContractAddress("addressSetStorage"));
        // Initialize minipool & get properties
        RocketMinipoolInterface minipool = RocketMinipoolInterface(msg.sender);
        address nodeAddress = minipool.getNodeAddress();
        // Set minipool validator pubkey & validator minipool address
        setBytes(keccak256(abi.encodePacked("minipool.pubkey", msg.sender)), _pubkey);
        setAddress(keccak256(abi.encodePacked("validator.minipool", _pubkey)), msg.sender);
        // Add minipool to node validating minipools index
        addressSetStorage.addItem(keccak256(abi.encodePacked("node.minipools.validating.index", nodeAddress)), msg.sender);
    }

    // Set a minipool's withdrawal balances and withdrawable status
    // Only accepts calls from the RocketMinipoolStatus contract
    function setMinipoolWithdrawalBalances(address _minipoolAddress, uint256 _total, uint256 _node) override external onlyLatestContract("rocketMinipoolManager", address(this)) onlyLatestContract("rocketMinipoolStatus", msg.sender) {
        setUint(keccak256(abi.encodePacked("minipool.withdrawal.balance.total", _minipoolAddress)), _total);
        setUint(keccak256(abi.encodePacked("minipool.withdrawal.balance.node", _minipoolAddress)), _node);
        setBool(keccak256(abi.encodePacked("minipool.withdrawable", _minipoolAddress)), true);
    }

    // Set a minipool's withdrawal processed status
    // Only accepts calls from the RocketNetworkWithdrawal contract
    function setMinipoolWithdrawalProcessed(address _minipoolAddress) override external onlyLatestContract("rocketMinipoolManager", address(this)) onlyLatestContract("rocketNetworkWithdrawal", msg.sender) {
        setBool(keccak256(abi.encodePacked("minipool.withdrawal.processed", _minipoolAddress)), true);
    }

}
