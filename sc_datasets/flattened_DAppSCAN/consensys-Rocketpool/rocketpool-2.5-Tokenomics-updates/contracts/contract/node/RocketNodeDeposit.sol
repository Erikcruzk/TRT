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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/deposit/RocketDepositPoolInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDepositPoolInterface {
    function getBalance() external view returns (uint256);
    function getExcessBalance() external view returns (uint256);
    function deposit() external payable;
    function recycleDissolvedDeposit() external payable;
    function recycleWithdrawnDeposit() external payable;
    function recycleLiquidatedStake() external payable;
    function assignDeposits() external;
    function withdrawExcessBalance(uint256 _amount) external;
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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/network/RocketNetworkFeesInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketNetworkFeesInterface {
    function getNodeDemand() external view returns (int256);
    function getNodeFee() external view returns (uint256);
    function getNodeFeeByDemand(int256 _nodeDemand) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/node/RocketNodeDepositInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketNodeDepositInterface {
    function deposit(uint256 _minimumNodeFee) external payable;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/protocol/settings/RocketDAOProtocolSettingsDepositInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAOProtocolSettingsDepositInterface {
    function getDepositEnabled() external view returns (bool);
    function getAssignDepositsEnabled() external view returns (bool);
    function getMinimumDeposit() external view returns (uint256);
    function getMaximumDepositPoolSize() external view returns (uint256);
    function getMaximumDepositAssignments() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/protocol/settings/RocketDAOProtocolSettingsMinipoolInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAOProtocolSettingsMinipoolInterface {
    function getLaunchBalance() external view returns (uint256);
    function getDepositNodeAmount(MinipoolDeposit _depositType) external view returns (uint256);
    function getFullDepositNodeAmount() external view returns (uint256);
    function getHalfDepositNodeAmount() external view returns (uint256);
    function getEmptyDepositNodeAmount() external view returns (uint256);
    function getDepositUserAmount(MinipoolDeposit _depositType) external view returns (uint256);
    function getFullDepositUserAmount() external view returns (uint256);
    function getHalfDepositUserAmount() external view returns (uint256);
    function getEmptyDepositUserAmount() external view returns (uint256);
    function getSubmitWithdrawableEnabled() external view returns (bool);
    function getLaunchTimeout() external view returns (uint256);
    function getWithdrawalDelay() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/protocol/settings/RocketDAOProtocolSettingsNodeInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAOProtocolSettingsNodeInterface {
    function getRegistrationEnabled() external view returns (bool);
    function getDepositEnabled() external view returns (bool);
    function getMinimumPerMinipoolStake() external view returns (uint256);
    function getMaximumPerMinipoolStake() external view returns (uint256);
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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/node/settings/RocketDAONodeTrustedSettingsMembersInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAONodeTrustedSettingsMembersInterface {
    function getQuorum() external view returns (uint256);
    function getRPLBond() external view returns(uint256);
    function getMinipoolUnbondedMax() external view returns(uint256);
    function getChallengeCooldown() external view returns(uint256);
    function getChallengeWindow() external view returns(uint256);
    function getChallengeCost() external view returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/node/RocketNodeDeposit.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only












// Handles node deposits and minipool creation

contract RocketNodeDeposit is RocketBase, RocketNodeDepositInterface {

    // Events
    event DepositReceived(address indexed from, uint256 amount, uint256 time);

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) {
        version = 1;
    }

    // Accept a node deposit and create a new minipool under the node
    // Only accepts calls from registered nodes
    function deposit(uint256 _minimumNodeFee) override external payable onlyLatestContract("rocketNodeDeposit", address(this)) onlyRegisteredNode(msg.sender) {
        // Load contracts
        RocketDepositPoolInterface rocketDepositPool = RocketDepositPoolInterface(getContractAddress("rocketDepositPool"));
        RocketDAOProtocolSettingsDepositInterface rocketDAOProtocolSettingsDeposit = RocketDAOProtocolSettingsDepositInterface(getContractAddress("rocketDAOProtocolSettingsDeposit"));
        RocketMinipoolManagerInterface rocketMinipoolManager = RocketMinipoolManagerInterface(getContractAddress("rocketMinipoolManager"));
        RocketDAOProtocolSettingsMinipoolInterface rocketDAOProtocolSettingsMinipool = RocketDAOProtocolSettingsMinipoolInterface(getContractAddress("rocketDAOProtocolSettingsMinipool"));
        RocketNetworkFeesInterface rocketNetworkFees = RocketNetworkFeesInterface(getContractAddress("rocketNetworkFees"));
        RocketDAOProtocolSettingsNodeInterface rocketDAOProtocolSettingsNode = RocketDAOProtocolSettingsNodeInterface(getContractAddress("rocketDAOProtocolSettingsNode"));
        RocketDAONodeTrustedInterface rocketDaoNodeTrusted = RocketDAONodeTrustedInterface(getContractAddress("rocketDAONodeTrusted"));
        RocketDAONodeTrustedSettingsMembersInterface rocketDaoNodeTrustedSettingsMembers = RocketDAONodeTrustedSettingsMembersInterface(getContractAddress("rocketDAONodeTrustedSettingsMembers"));
        // Check node settings
        require(rocketDAOProtocolSettingsNode.getDepositEnabled(), "Node deposits are currently disabled");
        // Check current node fee
        require(rocketNetworkFees.getNodeFee() >= _minimumNodeFee, "Minimum node fee exceeds current network node fee");
        // Get deposit type by node deposit amount
        MinipoolDeposit depositType = MinipoolDeposit.None;
        if (msg.value == rocketDAOProtocolSettingsMinipool.getFullDepositNodeAmount()) { depositType = MinipoolDeposit.Full; }
        else if (msg.value == rocketDAOProtocolSettingsMinipool.getHalfDepositNodeAmount()) { depositType = MinipoolDeposit.Half; }
        else if (msg.value == rocketDAOProtocolSettingsMinipool.getEmptyDepositNodeAmount()) { depositType = MinipoolDeposit.Empty; }
        // Check deposit type is valid
        require(depositType != MinipoolDeposit.None, "Invalid node deposit amount");
        // Node is trusted
        if (rocketDaoNodeTrusted.getMemberIsValid(msg.sender)) {
            // If creating an unbonded minipool, check current unbonded minipool count
            if (depositType == MinipoolDeposit.Empty) {
                require(rocketDaoNodeTrusted.getMemberUnbondedValidatorCount(msg.sender) < rocketDaoNodeTrustedSettingsMembers.getMinipoolUnbondedMax(), "Trusted node member would exceed the amount of unbonded minipools allowed");
            }
        }
        // Node is not trusted - it cannot create unbonded minipools
        else { require(depositType != MinipoolDeposit.Empty, "Only members of the trusted node DAO may create unbonded minipools"); }
        // Emit deposit received event
        emit DepositReceived(msg.sender, msg.value, block.timestamp);
        // Create minipool
        address minipoolAddress = rocketMinipoolManager.createMinipool(msg.sender, depositType);
        RocketMinipoolInterface minipool = RocketMinipoolInterface(minipoolAddress);
        // Transfer deposit to minipool
        minipool.nodeDeposit{value: msg.value}();
        // Assign deposits if enabled
        if (rocketDAOProtocolSettingsDeposit.getAssignDepositsEnabled()) { rocketDepositPool.assignDeposits(); }
    }

}
