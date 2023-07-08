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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/node/settings/RocketDAONodeTrustedSettingsInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAONodeTrustedSettingsInterface {
    function getSettingUint(string memory _settingPath) external view returns (uint256);
    function setSettingUint(string memory _settingPath, uint256 _value) external;
    function getSettingBool(string memory _settingPath) external view returns (bool);
    function setSettingBool(string memory _settingPath, bool _value) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/dao/node/settings/RocketDAONodeTrustedSettings.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only


// Settings in RP which the DAO will have full control over
// This settings contract enables storage using setting paths with namespaces, rather than explicit set methods
abstract contract RocketDAONodeTrustedSettings is RocketBase, RocketDAONodeTrustedSettingsInterface {


    // The namespace for a particular group of settings
    bytes32 settingNameSpace = '';


    // Only allow updating from the DAO proposals contract
    modifier onlyDAONodeTrustedProposal() {
        // If this contract has been initialised, only allow access from the proposals contract
        if(getBool(keccak256(abi.encodePacked(settingNameSpace, "deployed")))) require(getContractAddress('rocketDAONodeTrustedProposals') == msg.sender, "Only DAO Node Trusted Proposals contract can update a setting");
        _;
    }


    // Construct
    constructor(address _rocketStorageAddress, string memory _settingNameSpace) RocketBase(_rocketStorageAddress) {
        // Apply the setting namespace
        settingNameSpace = keccak256(abi.encodePacked("dao.trustednodes.setting", _settingNameSpace));
    }


    /*** Uints  ****************/

    // A general method to return any setting given the setting path is correct, only accepts uints
    function getSettingUint(string memory _settingPath) public view override returns (uint256) {
        return getUint(keccak256(abi.encodePacked(settingNameSpace, _settingPath)));
    } 

    // Update a Uint setting, can only be executed by the DAO contract when a majority on a setting proposal has passed and been executed
    function setSettingUint(string memory _settingPath, uint256 _value) virtual public override onlyDAONodeTrustedProposal {
        // Update setting now
        setUint(keccak256(abi.encodePacked(settingNameSpace, _settingPath)), _value);
    } 
   

    /*** Bools  ****************/

    // A general method to return any setting given the setting path is correct, only accepts bools
    function getSettingBool(string memory _settingPath) public view override returns (bool) {
        return getBool(keccak256(abi.encodePacked(settingNameSpace, _settingPath)));
    } 

    // Update a setting, can only be executed by the DAO contract when a majority on a setting proposal has passed and been executed
    function setSettingBool(string memory _settingPath, bool _value) virtual public override onlyDAONodeTrustedProposal {
        // Update setting now
        setBool(keccak256(abi.encodePacked(settingNameSpace, _settingPath)), _value);
    }

}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/node/settings/RocketDAONodeTrustedSettingsProposalsInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAONodeTrustedSettingsProposalsInterface {
    function getCooldown() external view returns(uint256);
    function getVoteBlocks() external view returns(uint256);
    function getVoteDelayBlocks() external view returns(uint256);
    function getExecuteBlocks() external view returns(uint256);
    function getActionBlocks() external view returns(uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/dao/node/settings/RocketDAONodeTrustedSettingsProposals.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only


// The Trusted Node DAO Members 
contract RocketDAONodeTrustedSettingsProposals is RocketDAONodeTrustedSettings, RocketDAONodeTrustedSettingsProposalsInterface { 

    // Construct
    constructor(address _rocketStorageAddress) RocketDAONodeTrustedSettings(_rocketStorageAddress, "proposals") {
        // Set version
        version = 1;
        // Initialize settings on deployment
        if(!getBool(keccak256(abi.encodePacked(settingNameSpace, "deployed")))) {
            // Init settings
            setSettingUint('proposal.cooldown', 13220);                      // How long before a member can make sequential proposals. Approx. 2 days of blocks
            setSettingUint('proposal.vote.blocks', 92550);                   // How long a proposal can be voted on. Approx. 2 weeks worth of blocks
            setSettingUint('proposal.vote.delay.blocks', 1);                 // How long before a proposal can be voted on after it is created. Approx. Next Block
            setSettingUint('proposal.execute.blocks', 185100);               // How long a proposal can be executed after its voting period is finished. Approx. 4 weeks worth of blocks
            setSettingUint('proposal.action.blocks', 185100);                // Certain proposals require a secondary action to be run after the proposal is successful (joining, leaving etc). This is how long until that action expires Approx. 2 weeks worth of blocks     
            // Settings initialized
            setBool(keccak256(abi.encodePacked(settingNameSpace, "deployed")), true);
        }
    }

  
    // Getters

    // How long before a member can make sequential proposals. Approx. 2 days of blocks
    function getCooldown() override public view returns (uint256) { 
        return getSettingUint('proposal.cooldown');
    }

    // How long a proposal can be voted on. Approx. 2 weeks worth of blocks
    function getVoteBlocks() override public view returns (uint256) { 
        return getSettingUint('proposal.vote.blocks');
    }

    // How long before a proposal can be voted on after it is created. Approx. Next Block
    function getVoteDelayBlocks() override public view returns (uint256) { 
        return getSettingUint('proposal.vote.delay.blocks');
    }

    // How long a proposal can be executed after its voting period is finished Approx. 4 weeks worth of blocks
    function getExecuteBlocks() override public view returns (uint256) { 
        return getSettingUint('proposal.execute.blocks');
    }

    // Certain proposals require a secondary action to be run after the proposal is successful (joining, leaving etc). This is how long until that action expires Approx. 2 weeks worth of blocks
    function getActionBlocks() override public view returns (uint256) { 
        return getSettingUint('proposal.action.blocks');
    }
        

}
