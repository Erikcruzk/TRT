// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/utils/Lib_Bytes32Utils.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title Lib_Byte32Utils
 */
library Lib_Bytes32Utils {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Converts a bytes32 value to a boolean. Anything non-zero will be converted to "true."
     * @param _in Input bytes32 value.
     * @return Bytes32 as a boolean.
     */
    function toBool(
        bytes32 _in
    )
        internal
        pure
        returns (
            bool
        )
    {
        return _in != 0;
    }

    /**
     * Converts a boolean to a bytes32 value.
     * @param _in Input boolean value.
     * @return Boolean as a bytes32.
     */
    function fromBool(
        bool _in
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return bytes32(uint256(_in ? 1 : 0));
    }

    /**
     * Converts a bytes32 value to an address. Takes the *last* 20 bytes.
     * @param _in Input bytes32 value.
     * @return Bytes32 as an address.
     */
    function toAddress(
        bytes32 _in
    )
        internal
        pure
        returns (
            address
        )
    {
        return address(uint160(uint256(_in)));
    }

    /**
     * Converts an address to a bytes32.
     * @param _in Input address value.
     * @return Address as a bytes32.
     */
    function fromAddress(
        address _in
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return bytes32(uint256(_in));
    }

    /**
     * Removes the leading zeros from a bytes32 value and returns a new (smaller) bytes value.
     * @param _in Input bytes32 value.
     * @return Bytes32 without any leading zeros.
     */
    function removeLeadingZeros(
        bytes32 _in
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        bytes memory out;

        assembly {
            // Figure out how many leading zero bytes to remove.
            let shift := 0
            for { let i := 0 } and(lt(i, 32), eq(byte(i, _in), 0)) { i := add(i, 1) } {
                shift := add(shift, 1)
            }

            // Reserve some space for our output and fix the free memory pointer.
            out := mload(0x40)
            mstore(0x40, add(out, 0x40))

            // Shift the value and store it into the output bytes.
            mstore(add(out, 0x20), shl(mul(shift, 8), _in))

            // Store the new size (with leading zero bytes removed) in the output byte size.
            mstore(out, sub(32, shift))
        }

        return out;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/precompiles/iOVM_DeployerWhitelist.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iOVM_DeployerWhitelist
 */
interface iOVM_DeployerWhitelist {

    /********************
     * Public Functions *
     ********************/

    function initialize(address _owner, bool _allowArbitraryDeployment) external;
    function getOwner() external returns (address _owner);
    function setWhitelistedDeployer(address _deployer, bool _isWhitelisted) external;
    function setOwner(address _newOwner) external;
    function setAllowArbitraryDeployment(bool _allowArbitraryDeployment) external;
    function enableArbitraryContractDeployment() external;
    function isDeployerAllowed(address _deployer) external returns (bool _allowed);
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/utils/Lib_ErrorUtils.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/**
 * @title Lib_ErrorUtils
 */
library Lib_ErrorUtils {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Encodes an error string into raw solidity-style revert data.
     * (i.e. ascii bytes, prefixed with bytes4(keccak("Error(string))"))
     * Ref: https://docs.soliditylang.org/en/v0.8.2/control-structures.html?highlight=Error(string)#panic-via-assert-and-error-via-require
     * @param _reason Reason for the reversion.
     * @return Standard solidity revert data for the given reason.
     */
    function encodeRevertString(
        string memory _reason
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodeWithSignature(
            "Error(string)",
            _reason
        );
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/wrappers/Lib_SafeExecutionManagerWrapper.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */

/**
 * @title Lib_SafeExecutionManagerWrapper
 * @dev The Safe Execution Manager Wrapper provides functions which facilitate writing OVM safe 
 * code using the standard solidity compiler, by routing all its operations through the Execution 
 * Manager.
 * 
 * Compiler used: solc
 * Runtime target: OVM
 */
library Lib_SafeExecutionManagerWrapper {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Performs a safe ovmCALL.
     * @param _gasLimit Gas limit for the call.
     * @param _target Address to call.
     * @param _calldata Data to send to the call.
     * @return _success Whether or not the call reverted.
     * @return _returndata Data returned by the call.
     */
    function safeCALL(
        uint256 _gasLimit,
        address _target,
        bytes memory _calldata
    )
        internal
        returns (
            bool _success,
            bytes memory _returndata
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCALL(uint256,address,bytes)",
                _gasLimit,
                _target,
                _calldata
            )
        );

        return abi.decode(returndata, (bool, bytes));
    }

    /**
     * Performs a safe ovmDELEGATECALL.
     * @param _gasLimit Gas limit for the call.
     * @param _target Address to call.
     * @param _calldata Data to send to the call.
     * @return _success Whether or not the call reverted.
     * @return _returndata Data returned by the call.
     */
    function safeDELEGATECALL(
        uint256 _gasLimit,
        address _target,
        bytes memory _calldata
    )
        internal
        returns (
            bool _success,
            bytes memory _returndata
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmDELEGATECALL(uint256,address,bytes)",
                _gasLimit,
                _target,
                _calldata
            )
        );

        return abi.decode(returndata, (bool, bytes));
    }

    /**
     * Performs a safe ovmCREATE call.
     * @param _gasLimit Gas limit for the creation.
     * @param _bytecode Code for the new contract.
     * @return _contract Address of the created contract.
     */
    function safeCREATE(
        uint256 _gasLimit,
        bytes memory _bytecode
    )
        internal
        returns (
            address,
            bytes memory
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            _gasLimit,
            abi.encodeWithSignature(
                "ovmCREATE(bytes)",
                _bytecode
            )
        );

        return abi.decode(returndata, (address, bytes));
    }

    /**
     * Performs a safe ovmEXTCODESIZE call.
     * @param _contract Address of the contract to query the size of.
     * @return _EXTCODESIZE Size of the requested contract in bytes.
     */
    function safeEXTCODESIZE(
        address _contract
    )
        internal
        returns (
            uint256 _EXTCODESIZE
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmEXTCODESIZE(address)",
                _contract
            )
        );

        return abi.decode(returndata, (uint256));
    }

    /**
     * Performs a safe ovmCHAINID call.
     * @return _CHAINID Result of calling ovmCHAINID.
     */
    function safeCHAINID()
        internal
        returns (
            uint256 _CHAINID
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCHAINID()"
            )
        );

        return abi.decode(returndata, (uint256));
    }

    /**
     * Performs a safe ovmCALLER call.
     * @return _CALLER Result of calling ovmCALLER.
     */
    function safeCALLER()
        internal
        returns (
            address _CALLER
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCALLER()"
            )
        );

        return abi.decode(returndata, (address));
    }

    /**
     * Performs a safe ovmADDRESS call.
     * @return _ADDRESS Result of calling ovmADDRESS.
     */
    function safeADDRESS()
        internal
        returns (
            address _ADDRESS
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmADDRESS()"
            )
        );

        return abi.decode(returndata, (address));
    }

    /**
     * Performs a safe ovmGETNONCE call.
     * @return _nonce Result of calling ovmGETNONCE.
     */
    function safeGETNONCE()
        internal
        returns (
            uint64 _nonce
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmGETNONCE()"
            )
        );

        return abi.decode(returndata, (uint64));
    }

    /**
     * Performs a safe ovmSETNONCE call.
     * @param _nonce New account nonce.
     */
    function safeSETNONCE(
        uint64 _nonce
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmSETNONCE(uint64)",
                _nonce
            )
        );
    }

    /**
     * Performs a safe ovmCREATEEOA call.
     * @param _messageHash Message hash which was signed by EOA
     * @param _v v value of signature (0 or 1)
     * @param _r r value of signature
     * @param _s s value of signature
     */
    function safeCREATEEOA(
        bytes32 _messageHash,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCREATEEOA(bytes32,uint8,bytes32,bytes32)",
                _messageHash,
                _v,
                _r,
                _s
            )
        );
    }

    /**
     * Performs a safe REVERT.
     * @param _reason String revert reason to pass along with the REVERT.
     */
    function safeREVERT(
        string memory _reason
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmREVERT(bytes)",
                Lib_ErrorUtils.encodeRevertString(
                    _reason
                )
            )
        );
    }

    /**
     * Performs a safe "require".
     * @param _condition Boolean condition that must be true or will revert.
     * @param _reason String revert reason to pass along with the REVERT.
     */
    function safeREQUIRE(
        bool _condition,
        string memory _reason
    )
        internal
    {
        if (!_condition) {
            safeREVERT(
                _reason
            );
        }
    }

    /**
     * Performs a safe ovmSLOAD call.
     */
    function safeSLOAD(
        bytes32 _key
    )
        internal
        returns (
            bytes32
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmSLOAD(bytes32)",
                _key
            )
        );

        return abi.decode(returndata, (bytes32));
    }

    /**
     * Performs a safe ovmSSTORE call.
     */
    function safeSSTORE(
        bytes32 _key,
        bytes32 _value
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmSSTORE(bytes32,bytes32)",
                _key,
                _value
            )
        );
    }

    /*********************
     * Private Functions *
     *********************/

    /**
     * Performs an ovm interaction and the necessary safety checks.
     * @param _gasLimit Gas limit for the interaction.
     * @param _calldata Data to send to the OVM_ExecutionManager (encoded with sighash).
     * @return _returndata Data sent back by the OVM_ExecutionManager.
     */
    function _safeExecutionManagerInteraction(
        uint256 _gasLimit,
        bytes memory _calldata
    )
        private
        returns (
            bytes memory _returndata
        )
    {
        address ovmExecutionManager = msg.sender;
        (
            bool success,
            bytes memory returndata
        ) = ovmExecutionManager.call{gas: _gasLimit}(_calldata);

        if (success == false) {
            assembly {
                revert(add(returndata, 0x20), mload(returndata))
            }
        } else if (returndata.length == 1) {
            assembly {
                return(0, 1)
            }
        } else {
            return returndata;
        }
    }

    function _safeExecutionManagerInteraction(
        bytes memory _calldata
    )
        private
        returns (
            bytes memory _returndata
        )
    {
        return _safeExecutionManagerInteraction(
            gasleft(),
            _calldata
        );
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/OVM/precompiles/OVM_DeployerWhitelist.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */

/* Interface Imports */


/**
 * @title OVM_DeployerWhitelist
 * @dev The Deployer Whitelist is a temporary predeploy used to provide additional safety during the
 * initial phases of our mainnet roll out. It is owned by the Optimism team, and defines accounts
 * which are allowed to deploy contracts on Layer2. The Execution Manager will only allow an 
 * ovmCREATE or ovmCREATE2 operation to proceed if the deployer's address whitelisted.
 * 
 * Compiler used: solc
 * Runtime target: OVM
 */
contract OVM_DeployerWhitelist is iOVM_DeployerWhitelist {

    /**********************
     * Contract Constants *
     **********************/

    bytes32 internal constant KEY_INITIALIZED =                0x0000000000000000000000000000000000000000000000000000000000000010;
    bytes32 internal constant KEY_OWNER =                      0x0000000000000000000000000000000000000000000000000000000000000011;
    bytes32 internal constant KEY_ALLOW_ARBITRARY_DEPLOYMENT = 0x0000000000000000000000000000000000000000000000000000000000000012;


    /**********************
     * Function Modifiers *
     **********************/
    
    /**
     * Blocks functions to anyone except the contract owner.
     */
    modifier onlyOwner() {
        address owner = Lib_Bytes32Utils.toAddress(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(
                KEY_OWNER
            )
        );

        Lib_SafeExecutionManagerWrapper.safeREQUIRE(
            Lib_SafeExecutionManagerWrapper.safeCALLER() == owner,
            "Function can only be called by the owner of this contract."
        );
        _;
    }


    /********************
     * Public Functions *
     ********************/
    
    /**
     * Initializes the whitelist.
     * @param _owner Address of the owner for this contract.
     * @param _allowArbitraryDeployment Whether or not to allow arbitrary contract deployment.
     */
    function initialize(
        address _owner,
        bool _allowArbitraryDeployment
    )
        override
        public
    {
        bool initialized = Lib_Bytes32Utils.toBool(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(KEY_INITIALIZED)
        );

        if (initialized == true) {
            return;
        }

        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            KEY_INITIALIZED,
            Lib_Bytes32Utils.fromBool(true)
        );
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            KEY_OWNER,
            Lib_Bytes32Utils.fromAddress(_owner)
        );
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            KEY_ALLOW_ARBITRARY_DEPLOYMENT,
            Lib_Bytes32Utils.fromBool(_allowArbitraryDeployment)
        );
    }

    /**
     * Gets the owner of the whitelist.
     */
    function getOwner()
        override
        public
        returns(
            address
        )
    {
        return Lib_Bytes32Utils.toAddress(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(
                KEY_OWNER
            )
        );
    }

    /**
     * Adds or removes an address from the deployment whitelist.
     * @param _deployer Address to update permissions for.
     * @param _isWhitelisted Whether or not the address is whitelisted.
     */
    function setWhitelistedDeployer(
        address _deployer,
        bool _isWhitelisted
    )
        override
        public
        onlyOwner
    {
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            Lib_Bytes32Utils.fromAddress(_deployer),
            Lib_Bytes32Utils.fromBool(_isWhitelisted)
        );
    }

    /**
     * Updates the owner of this contract.
     * @param _owner Address of the new owner.
     */
    function setOwner(
        address _owner
    )
        override
        public
        onlyOwner
    {
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            KEY_OWNER,
            Lib_Bytes32Utils.fromAddress(_owner)
        );
    }

    /**
     * Updates the arbitrary deployment flag.
     * @param _allowArbitraryDeployment Whether or not to allow arbitrary contract deployment.
     */
    function setAllowArbitraryDeployment(
        bool _allowArbitraryDeployment
    )
        override
        public
        onlyOwner
    {
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            KEY_ALLOW_ARBITRARY_DEPLOYMENT,
            Lib_Bytes32Utils.fromBool(_allowArbitraryDeployment)
        );
    }

    /**
     * Permanently enables arbitrary contract deployment and deletes the owner.
     */
    function enableArbitraryContractDeployment()
        override
        public
        onlyOwner
    {
        setAllowArbitraryDeployment(true);
        setOwner(address(0));
    }

    /**
     * Checks whether an address is allowed to deploy contracts.
     * @param _deployer Address to check.
     * @return _allowed Whether or not the address can deploy contracts.
     */
    function isDeployerAllowed(
        address _deployer
    )
        override
        public
        returns (
            bool _allowed
        )
    {
        bool initialized = Lib_Bytes32Utils.toBool(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(KEY_INITIALIZED)
        );

        if (initialized == false) {
            return true;
        }

        bool allowArbitraryDeployment = Lib_Bytes32Utils.toBool(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(KEY_ALLOW_ARBITRARY_DEPLOYMENT)
        );

        if (allowArbitraryDeployment == true) {
            return true;
        }

        bool isWhitelisted = Lib_Bytes32Utils.toBool(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(
                Lib_Bytes32Utils.fromAddress(_deployer)
            )
        );

        return isWhitelisted;        
    }
}
