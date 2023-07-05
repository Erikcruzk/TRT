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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/protocol/RocketDAOProtocolInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAOProtocolInterface {
    function getBootstrapModeDisabled() external view returns (bool);
    function bootstrapSettingUint(string memory _settingContractName, string memory _settingPath, uint256 _value) external;
    function bootstrapSettingBool(string memory _settingContractName, string memory _settingPath, bool _value) external;
    function bootstrapSettingAddress(string memory _settingContractName, string memory _settingPath, address _value) external;
    function bootstrapSettingClaimer(string memory _contractName, uint256 _perc) external;
    function bootstrapSpendTreasury(string memory _invoiceID, address _recipientAddress, uint256 _amount) external;
    function bootstrapDisable(bool _confirmDisableBootstrapMode) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/dao/protocol/RocketDAOProtocol.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only


// The Rocket Pool Network DAO - This is a placeholder for the network DAO to come
contract RocketDAOProtocol is RocketBase, RocketDAOProtocolInterface {

    // The namespace for any data stored in the network DAO (do not change)
    string private daoNameSpace = 'dao.protocol';

    // Only allow bootstrapping when enabled
    modifier onlyBootstrapMode() {
        require(getBootstrapModeDisabled() == false, "Bootstrap mode not engaged");
        _;
    }
    
    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) {
        // Version
        version = 1;
    }


    /**** DAO Properties **************/

    // Returns true if bootstrap mode is disabled
    function getBootstrapModeDisabled() override public view returns (bool) { 
        return getBool(keccak256(abi.encodePacked(daoNameSpace, "bootstrapmode.disabled"))); 
    }


    /**** Bootstrapping ***************/
    // While bootstrap mode is engaged, RP can change settings alongside the DAO (when its implemented). When disabled, only DAO will be able to control settings

    // Bootstrap mode - Uint Setting
    function bootstrapSettingUint(string memory _settingContractName, string memory _settingPath, uint256 _value) override public onlyGuardian onlyBootstrapMode onlyLatestContract("rocketDAOProtocol", address(this)) {
        // Ok good to go, lets update the settings 
        (bool success, bytes memory response) = getContractAddress('rocketDAOProtocolProposals').call(abi.encodeWithSignature("proposalSettingUint(string,string,uint256)", _settingContractName, _settingPath, _value));
        // Was there an error?
        require(success, getRevertMsg(response));
    }

    // Bootstrap mode - Bool Setting
    function bootstrapSettingBool(string memory _settingContractName, string memory _settingPath, bool _value) override public onlyGuardian onlyBootstrapMode onlyLatestContract("rocketDAOProtocol", address(this)) {
        // Ok good to go, lets update the settings 
        (bool success, bytes memory response) = getContractAddress('rocketDAOProtocolProposals').call(abi.encodeWithSignature("proposalSettingBool(string,string,bool)", _settingContractName, _settingPath, _value));
        // Was there an error?
        require(success, getRevertMsg(response));
    }

    // Bootstrap mode - Address Setting
    function bootstrapSettingAddress(string memory _settingContractName, string memory _settingPath, address _value) override public onlyGuardian onlyBootstrapMode onlyLatestContract("rocketDAOProtocol", address(this)) {
        // Ok good to go, lets update the settings 
        (bool success, bytes memory response) = getContractAddress('rocketDAOProtocolProposals').call(abi.encodeWithSignature("proposalSettingAddress(string,string,address)", _settingContractName, _settingPath, _value));
        // Was there an error?
        require(success, getRevertMsg(response));
    }

    // Bootstrap mode - Set a claiming contract to receive a % of RPL inflation rewards
    function bootstrapSettingClaimer(string memory _contractName, uint256 _perc) override public onlyGuardian onlyBootstrapMode onlyLatestContract("rocketDAOProtocol", address(this)) {
        // Ok good to go, lets update the rewards claiming contract amount 
        (bool success, bytes memory response) = getContractAddress('rocketDAOProtocolProposals').call(abi.encodeWithSignature("proposalSettingRewardsClaimer(string,uint256)", _contractName, _perc));
        // Was there an error?
        require(success, getRevertMsg(response));
    } 

    // Bootstrap mode -Spend DAO treasury
    function bootstrapSpendTreasury(string memory _invoiceID, address _recipientAddress, uint256 _amount) override public onlyGuardian onlyBootstrapMode onlyLatestContract("rocketDAOProtocol", address(this)) {
        // Ok good to go, lets update the rewards claiming contract amount 
        (bool success, bytes memory response) = getContractAddress('rocketDAOProtocolProposals').call(abi.encodeWithSignature("proposalSpendTreasury(string,address,uint256)", _invoiceID, _recipientAddress, _amount));
        // Was there an error?
        require(success, getRevertMsg(response));
    }


    // Bootstrap mode - Disable RP Access (only RP can call this to hand over full control to the DAO)
    function bootstrapDisable(bool _confirmDisableBootstrapMode) override public onlyGuardian onlyBootstrapMode onlyLatestContract("rocketDAOProtocol", address(this)) {
        require(_confirmDisableBootstrapMode == true, 'You must confirm disabling bootstrap mode, it can only be done once!');
        setBool(keccak256(abi.encodePacked(daoNameSpace, "bootstrapmode.disabled")), true); 
    }

}
