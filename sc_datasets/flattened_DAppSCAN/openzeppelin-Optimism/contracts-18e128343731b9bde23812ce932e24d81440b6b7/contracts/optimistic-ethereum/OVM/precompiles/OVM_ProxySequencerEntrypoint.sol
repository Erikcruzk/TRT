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

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/OVM/precompiles/OVM_ProxySequencerEntrypoint.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */

/**
 * @title OVM_ProxySequencerEntrypoint 
 * @dev The Proxy Sequencer Entrypoint is a predeployed proxy to the implementation of the 
 * Sequencer Entrypoint. This will enable the Optimism team to upgrade the Sequencer Entrypoint 
 * contract.
 * 
 * Compiler used: solc
 * Runtime target: OVM
 */
contract OVM_ProxySequencerEntrypoint {

    /*********************
     * Fallback Function *
     *********************/

    fallback()
        external
    {
        //SWC-Unchecked Call Return Value: L26-L30
        Lib_SafeExecutionManagerWrapper.safeDELEGATECALL(
            gasleft(),
            _getImplementation(),
            msg.data
        );
    }


    /********************
     * Public Functions *
     ********************/

    function init(
        address _implementation,
        address _owner
    )
        external
    {
        Lib_SafeExecutionManagerWrapper.safeREQUIRE(
            _getOwner() == address(0),
            "ProxySequencerEntrypoint has already been inited"
        );
        _setOwner(_owner);
        _setImplementation(_implementation);
    }

    function upgrade(
        address _implementation
    )
        external
    {
        Lib_SafeExecutionManagerWrapper.safeREQUIRE(
            _getOwner() == Lib_SafeExecutionManagerWrapper.safeCALLER(),
            "Only owner can upgrade the Entrypoint"
        );

        _setImplementation(_implementation);
    }


    /**********************
     * Internal Functions *
     **********************/

    function _setImplementation(
        address _implementation
    )
        internal
    {
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            bytes32(uint256(0)),
            bytes32(uint256(uint160(_implementation)))
        );
    }

    function _getImplementation()
        internal
        returns (
            address _implementation
        )
    {
        return address(uint160(uint256(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(
                bytes32(uint256(0))
            )
        )));
    }

    function _setOwner(
        address _owner
    )
        internal
    {
        Lib_SafeExecutionManagerWrapper.safeSSTORE(
            bytes32(uint256(1)),
            bytes32(uint256(uint160(_owner)))
        );
    }

    function _getOwner()
        internal
        returns (
            address _owner
        )
    {
        return address(uint160(uint256(
            Lib_SafeExecutionManagerWrapper.safeSLOAD(
                bytes32(uint256(1))
            )
        )));
    }
}
