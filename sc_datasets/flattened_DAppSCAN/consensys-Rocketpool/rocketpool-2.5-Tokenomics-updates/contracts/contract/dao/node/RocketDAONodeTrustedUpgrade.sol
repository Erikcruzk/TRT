// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/dao/node/RocketDAONodeTrustedUpgradeInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketDAONodeTrustedUpgradeInterface {
    function upgrade(string memory _type, string memory _name, string memory _contractAbi, address _contractAddress) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/dao/node/RocketDAONodeTrustedUpgrade.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only


// Handles network contract upgrades

contract RocketDAONodeTrustedUpgrade is RocketBase, RocketDAONodeTrustedUpgradeInterface {

    // Events
    event ContractUpgraded(bytes32 indexed name, address indexed oldAddress, address indexed newAddress, uint256 time);
    event ContractAdded(bytes32 indexed name, address indexed newAddress, uint256 time);
    event ABIUpgraded(bytes32 indexed name, uint256 time);
    event ABIAdded(bytes32 indexed name, uint256 time);

    // Construct
    constructor(address _rocketStorageAddress) RocketBase(_rocketStorageAddress) {
        version = 1;
    }

    // Main accessor for performing an upgrade, be it a contract or abi for a contract
    // Will require > 50% of trusted DAO members to run when bootstrap mode is disabled
    function upgrade(string memory _type, string memory _name, string memory _contractAbi, address _contractAddress) override public onlyLatestContract("rocketDAONodeTrustedProposals", msg.sender) {
        // What action are we performing?
        bytes32 typeHash = keccak256(abi.encodePacked(_type));
        // Lets do it!
        if(typeHash == keccak256(abi.encodePacked("upgradeContract"))) _upgradeContract(_name, _contractAddress, _contractAbi);
        if(typeHash == keccak256(abi.encodePacked("addContract"))) _addContract(_name, _contractAddress, _contractAbi);
        if(typeHash == keccak256(abi.encodePacked("upgradeABI"))) _upgradeABI(_name, _contractAbi);
        if(typeHash == keccak256(abi.encodePacked("addABI"))) _addABI(_name, _contractAbi);
    }


    /*** Internal Upgrade Methods for the Trusted Node DAO ****************/

    // Upgrade a network contract
    function _upgradeContract(string memory _name, address _contractAddress, string memory _contractAbi) internal {
        // Check contract being upgraded
        bytes32 nameHash = keccak256(abi.encodePacked(_name));
        require(nameHash != keccak256(abi.encodePacked("rocketVault")),        "Cannot upgrade the vault");
        require(nameHash != keccak256(abi.encodePacked("rocketPoolToken")),    "Cannot upgrade token contracts");
        require(nameHash != keccak256(abi.encodePacked("rocketTokenRETH")),     "Cannot upgrade token contracts");
        require(nameHash != keccak256(abi.encodePacked("rocketTokenNETH")), "Cannot upgrade token contracts");
        require(nameHash != keccak256(abi.encodePacked("casperDeposit")),      "Cannot upgrade the casper deposit contract");
        // Get old contract address & check contract exists
        address oldContractAddress = getAddress(keccak256(abi.encodePacked("contract.address", _name)));
        require(oldContractAddress != address(0x0), "Contract does not exist");
        // Check new contract address
        require(_contractAddress != address(0x0), "Invalid contract address");
        require(_contractAddress != oldContractAddress, "The contract address cannot be set to its current address");
        // Register new contract
        setBool(keccak256(abi.encodePacked("contract.exists", _contractAddress)), true);
        setString(keccak256(abi.encodePacked("contract.name", _contractAddress)), _name);
        setAddress(keccak256(abi.encodePacked("contract.address", _name)), _contractAddress);
        setString(keccak256(abi.encodePacked("contract.abi", _name)), _contractAbi);
        // Deregister old contract
        deleteString(keccak256(abi.encodePacked("contract.name", oldContractAddress)));
        deleteBool(keccak256(abi.encodePacked("contract.exists", oldContractAddress)));
        // Emit contract upgraded event
        emit ContractUpgraded(nameHash, oldContractAddress, _contractAddress, block.timestamp);
    }

    // Add a new network contract
    function _addContract(string memory _name, address _contractAddress, string memory _contractAbi) internal {
        // Check contract name
        bytes32 nameHash = keccak256(abi.encodePacked(_name));
        require(nameHash != keccak256(abi.encodePacked("")), "Invalid contract name");
        require(getAddress(keccak256(abi.encodePacked("contract.address", _name))) == address(0x0), "Contract name is already in use");
        string memory existingAbi = getString(keccak256(abi.encodePacked("contract.abi", _name)));
        require(keccak256(abi.encodePacked(existingAbi)) == keccak256(abi.encodePacked("")), "Contract name is already in use");
        // Check contract address
        require(_contractAddress != address(0x0), "Invalid contract address");
        require(!getBool(keccak256(abi.encodePacked("contract.exists", _contractAddress))), "Contract address is already in use");
        // Register contract
        setBool(keccak256(abi.encodePacked("contract.exists", _contractAddress)), true);
        setString(keccak256(abi.encodePacked("contract.name", _contractAddress)), _name);
        setAddress(keccak256(abi.encodePacked("contract.address", _name)), _contractAddress);
        setString(keccak256(abi.encodePacked("contract.abi", _name)), _contractAbi);
        // Emit contract added event
        emit ContractAdded(nameHash, _contractAddress, block.timestamp);
    }

    // Upgrade a network contract ABI
    function _upgradeABI(string memory _name, string memory _contractAbi) internal {
        // Check ABI exists
        string memory existingAbi = getString(keccak256(abi.encodePacked("contract.abi", _name)));
        require(keccak256(abi.encodePacked(existingAbi)) != keccak256(abi.encodePacked("")), "ABI does not exist");
        // Set ABI
        setString(keccak256(abi.encodePacked("contract.abi", _name)), _contractAbi);
        // Emit ABI upgraded event
        emit ABIUpgraded(keccak256(abi.encodePacked(_name)), block.timestamp);
    }

    // Add a new network contract ABI
    function _addABI(string memory _name, string memory _contractAbi) internal {
        // Check ABI name
        bytes32 nameHash = keccak256(abi.encodePacked(_name));
        require(nameHash != keccak256(abi.encodePacked("")), "Invalid ABI name");
        require(getAddress(keccak256(abi.encodePacked("contract.address", _name))) == address(0x0), "ABI name is already in use");
        string memory existingAbi = getString(keccak256(abi.encodePacked("contract.abi", _name)));
        require(keccak256(abi.encodePacked(existingAbi)) == keccak256(abi.encodePacked("")), "ABI name is already in use");
        // Set ABI
        setString(keccak256(abi.encodePacked("contract.abi", _name)), _contractAbi);
        // Emit ABI added event
        emit ABIAdded(nameHash, block.timestamp);
    }

}
