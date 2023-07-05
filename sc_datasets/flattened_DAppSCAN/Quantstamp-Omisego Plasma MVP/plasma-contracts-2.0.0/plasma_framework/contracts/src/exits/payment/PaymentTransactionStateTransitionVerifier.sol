// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/interfaces/IStateTransitionVerifier.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;

interface IStateTransitionVerifier {

    /**
    * @notice Verifies state transition logic
    * @param txBytes The transaction that does the state transition to verify
    * @param inputTxs Input transaction to the transaction to verify
    * @param outputIndexOfInputTxs Output index of the input txs that the transaction input points to
    */
    function isCorrectStateTransition(
        bytes calldata txBytes,
        bytes[] calldata inputTxs,
        uint16[] calldata outputIndexOfInputTxs
    )
        external
        view
        returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/payment/PaymentExitDataModel.sol

pragma solidity 0.5.11;

/**
 * @notice Model library for PaymentExit
 */
library PaymentExitDataModel {
    uint8 constant public MAX_INPUT_NUM = 5;
    uint8 constant public MAX_OUTPUT_NUM = 5;

    /**
     * @dev Exit model for a standard exit
     * @param exitable Boolean that defines whether exit is possible. Used by the challenge game to flag the result.
     * @param utxoPos The UTXO position of the transaction's exiting output
     * @param outputId The output identifier, in OutputId format
     * @param exitTarget The address to which the exit withdraws funds
     * @param amount The amount of funds to withdraw with this exit
     * @param bondSize The size of the bond put up for this exit to start, and which is used to cover the cost of challenges
     * @param bountySize The size of the bounty put up to cover the cost of processing the exit
     */
    struct StandardExit {
        bool exitable;
        uint256 utxoPos;
        bytes32 outputId;
        address payable exitTarget;
        uint256 amount;
        uint256 bondSize;
        uint256 bountySize;
    }

    /**
     * @dev Mapping of (exitId => StandardExit) that stores all standard exit data
     */
    struct StandardExitMap {
        mapping (uint168 => PaymentExitDataModel.StandardExit) exits;
    }

    /**
     * @dev The necessary data needed for processExit for in-flight exit inputs/outputs
     */
    struct WithdrawData {
        bytes32 outputId;
        address payable exitTarget;
        address token;
        uint256 amount;
        uint256 piggybackBondSize;
        uint256 bountySize;
    }

    /**
     * @dev Exit model for an in-flight exit
     * @param isCanonical A boolean that defines whether the exit is canonical
     *                    A canonical exit withdraws the outputs while a non-canonical exit withdraws the  inputs
     * @param exitStartTimestamp Timestamp for the start of the exit
     * @param exitMap A bitmap that stores piggyback flags
     * @param position The position of the youngest input of the in-flight exit transaction
     * @param inputs Fixed-size array of data required to withdraw inputs (if undefined, the default value is empty)
     * @param outputs Fixed-size array of data required to withdraw outputs (if undefined, the default value is empty)
     * @param bondOwner Recipient of the bond, when the in-flight exit is processed
     * @param bondSize The size of the bond put up for this exit to start. Used to cover the cost of challenges.
     * @param oldestCompetitorPosition The position of the oldest competing transaction
     *                                 The exiting transaction is only canonical if all competing transactions are younger.
     */
    struct InFlightExit {
        // Canonicity is assumed at start, and can be challenged and set to `false` after start
        // Response to non-canonical challenge can set it back to `true`
        bool isCanonical;
        uint64 exitStartTimestamp;

        /**
         * exit map Stores piggybacks and finalized exits
         * right most 0 ~ MAX_INPUT bits is flagged when input is piggybacked
         * right most MAX_INPUT ~ MAX_INPUT + MAX_OUTPUT bits is flagged when output is piggybacked
         */
        uint256 exitMap;
        uint256 position;
        WithdrawData[MAX_INPUT_NUM] inputs;
        WithdrawData[MAX_OUTPUT_NUM] outputs;
        address payable bondOwner;
        uint256 bondSize;
        uint256 oldestCompetitorPosition;
    }

    /**
     * @dev Mapping of (exitId => InFlightExit) that stores all in-flight exit data
     */
    struct InFlightExitMap {
        mapping (uint168 => PaymentExitDataModel.InFlightExit) exits;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/utils/RLPReader.sol

/**
 * @author Hamdi Allam hamdi.allam97@gmail.com
 * @notice RLP decoding library forked from https://github.com/hamdiallam/Solidity-RLP
 * @dev Some changes that were made to the library are:
 *      - Added more test cases from https://github.com/ethereum/tests/tree/master/RLPTests
 *      - Created more custom invalid test cases
 *      - Added more checks to ensure the decoder reads within bounds of the input length
 *      - Moved utility functions necessary to run some of the tests to the RLPMock.sol
*/

pragma solidity 0.5.11;

library RLPReader {
    uint8 constant internal STRING_SHORT_START = 0x80;
    uint8 constant internal STRING_LONG_START  = 0xb8;
    uint8 constant internal LIST_SHORT_START   = 0xc0;
    uint8 constant internal LIST_LONG_START    = 0xf8;
    uint8 constant internal MAX_SHORT_LEN      = 55;
    uint8 constant internal WORD_SIZE = 32;

    struct RLPItem {
        uint256 len;
        uint256 memPtr;
    }

    /**
     * @notice Convert a dynamic bytes array into an RLPItem
     * @param item RLP encoded bytes
     * @return An RLPItem
     */
    function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
        uint256 memPtr;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            memPtr := add(item, 0x20)
        }

        return RLPItem(item.length, memPtr);
    }

    /**
    * @notice Convert a dynamic bytes array into a list of RLPItems
    * @param item RLP encoded list in bytes
    * @return A list of RLPItems
    */
    function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
        require(isList(item), "Item is not a list");

        (uint256 listLength, uint256 offset) = decodeLengthAndOffset(item.memPtr);
        require(listLength == item.len, "Decoded RLP length for list is invalid");

        uint256 items = countEncodedItems(item);
        RLPItem[] memory result = new RLPItem[](items);

        uint256 dataMemPtr = item.memPtr + offset;
        uint256 dataLen;
        for (uint256 i = 0; i < items; i++) {
            (dataLen, ) = decodeLengthAndOffset(dataMemPtr);
            result[i] = RLPItem(dataLen, dataMemPtr);
            dataMemPtr = dataMemPtr + dataLen;
        }

        return result;
    }

    /**
    * @notice Check whether the RLPItem is either a list
    * @param item RLP encoded list in bytes
    * @return A boolean whether the RLPItem is a list
    */
    function isList(RLPItem memory item) internal pure returns (bool) {
        if (item.len == 0) return false;

        uint8 byte0;
        uint256 memPtr = item.memPtr;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            byte0 := byte(0, mload(memPtr))
        }

        if (byte0 < LIST_SHORT_START)
            return false;
        return true;
    }

    /**
     * @notice Create an address from a RLPItem
     * @dev Function is not a standard RLP decoding function and it used to decode to the Solidity native address type
     * @param item RLPItem
     */
    function toAddress(RLPItem memory item) internal pure returns (address) {
        require(item.len == 21, "Item length must be 21");
        require(!isList(item), "Item must not be a list");

        (uint256 itemLen, uint256 offset) = decodeLengthAndOffset(item.memPtr);
        require(itemLen == 21, "Decoded item length must be 21");

        uint256 dataMemPtr = item.memPtr + offset;
        uint256 result;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            result := mload(dataMemPtr)
            // right shift by 12 to make bytes20
            result := div(result, exp(256, 12))
        }

        return address(result);
    }

    /**
     * @notice Create a uint256 from a RLPItem. Leading zeros are invalid.
     * @dev Function is not a standard RLP decoding function and it used to decode to the Solidity native uint256 type
     * @param item RLPItem
     */
    function toUint(RLPItem memory item) internal pure returns (uint256) {
        require(item.len > 0 && item.len <= 33, "Item length must be between 1 and 33 bytes");
        require(!isList(item), "Item must not be a list");
        (uint256 itemLen, uint256 offset) = decodeLengthAndOffset(item.memPtr);
        require(itemLen == item.len, "Decoded item length must be equal to the input data length");

        uint256 dataLen = itemLen - offset;

        uint result;
        uint dataByte0;
        uint dataMemPtr = item.memPtr + offset;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            result := mload(dataMemPtr)
            dataByte0 := byte(0, result)
            // shift to the correct location if necessary
            if lt(dataLen, WORD_SIZE) {
                result := div(result, exp(256, sub(WORD_SIZE, dataLen)))
            }
        }
        // Special case: scalar 0 should be encoded as 0x80 and _not_ as 0x00
        require(!(dataByte0 == 0 && offset == 0), "Scalar 0 should be encoded as 0x80");

        // Disallow leading zeros
        require(!(dataByte0 == 0 && dataLen > 1), "Leading zeros are invalid");

        return result;
    }

    /**
     * @notice Create a bytes32 from a RLPItem
    * @dev Function is not a standard RLP decoding function and it used to decode to the Solidity native bytes32 type
     * @param item RLPItem
     */
    function toBytes32(RLPItem memory item) internal pure returns (bytes32) {
        // 1 byte for the length prefix
        require(item.len == 33, "Item length must be 33");
        require(!isList(item), "Item must not be a list");

        (uint256 itemLen, uint256 offset) = decodeLengthAndOffset(item.memPtr);
        require(itemLen == 33, "Decoded item length must be 33");

        uint256 dataMemPtr = item.memPtr + offset;
        bytes32 result;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            result := mload(dataMemPtr)
        }

        return result;
    }

    /**
    * @notice Counts the number of payload items inside an RLP encoded list
    * @param item RLPItem
    * @return The number of items in a inside an RLP encoded list
    */
    function countEncodedItems(RLPItem memory item) private pure returns (uint256) {
        uint256 count = 0;
        (, uint256 offset) = decodeLengthAndOffset(item.memPtr);
        uint256 currPtr = item.memPtr + offset;
        uint256 endPtr = item.memPtr + item.len;
        while (currPtr < endPtr) {
            (uint256 currLen, ) = decodeLengthAndOffset(currPtr);
            currPtr = currPtr + currLen;
            require(currPtr <= endPtr, "Invalid decoded length of RLP item found during counting items in a list");
            count++;
        }

        return count;
    }

    /**
     * @notice Decodes the RLPItem's length and offset.
     * @dev This function is dangerous. Ensure that the returned length is within bounds that memPtr points to.
     * @param memPtr Pointer to the dynamic bytes array in memory
     * @return The length of the RLPItem (including the length field) and the offset of the payload
     */
    function decodeLengthAndOffset(uint256 memPtr) internal pure returns (uint256, uint256) {
        uint256 decodedLength;
        uint256 offset;
        uint256 byte0;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            byte0 := byte(0, mload(memPtr))
        }

        if (byte0 < STRING_SHORT_START) {
            // Item is a single byte
            decodedLength = 1;
            offset = 0;
        } else if (STRING_SHORT_START <= byte0 && byte0 < STRING_LONG_START) {
            // The range of the first byte is between 0x80 and 0xb7 therefore it is a short string
            // decodedLength is between 1 and 56 bytes
            decodedLength = (byte0 - STRING_SHORT_START) + 1;
            if (decodedLength == 2){
                uint256 byte1;
                // solhint-disable-next-line no-inline-assembly
                assembly {
                    byte1 := byte(0, mload(add(memPtr, 1)))
                }
                // A single byte below 0x80 must be encoded as itself.
                require(byte1 >= STRING_SHORT_START, "Invalid short string encoding");
            }
            offset = 1;
        } else if (STRING_LONG_START <= byte0 && byte0 < LIST_SHORT_START) {
            // The range of the first byte is between 0xb8 and 0xbf therefore it is a long string
            // lengthLen is between 1 and 8 bytes
            // dataLen is greater than 55 bytes
            uint256 dataLen;
            uint256 byte1;
            uint256 lengthLen;

            // solhint-disable-next-line no-inline-assembly
            assembly {
                lengthLen := sub(byte0, 0xb7) // The length of the length of the payload is encoded in the first byte.
                memPtr := add(memPtr, 1) // skip over the first byte

                // right shift to the correct position
                dataLen := div(mload(memPtr), exp(256, sub(WORD_SIZE, lengthLen)))
                decodedLength := add(dataLen, add(lengthLen, 1))
                byte1 := byte(0, mload(memPtr))
            }

            // Check that the length has no leading zeros
            require(byte1 != 0, "Invalid leading zeros in length of the length for a long string");
            // Check that the value of length > MAX_SHORT_LEN
            require(dataLen > MAX_SHORT_LEN, "Invalid length for a long string");
            // Calculate the offset
            offset = lengthLen + 1;
        } else if (LIST_SHORT_START <= byte0 && byte0 < LIST_LONG_START) {
            // The range of the first byte is between 0xc0 and 0xf7 therefore it is a short list
            // decodedLength is between 1 and 56 bytes
            decodedLength = (byte0 - LIST_SHORT_START) + 1;
            offset = 1;
        } else {
            // The range of the first byte is between 0xf8 and 0xff therefore it is a long list
            // lengthLen is between 1 and 8 bytes
            // dataLen is greater than 55 bytes
            uint256 dataLen;
            uint256 byte1;
            uint256 lengthLen;

            // solhint-disable-next-line no-inline-assembly
            assembly {
                lengthLen := sub(byte0, 0xf7) // The length of the length of the payload is encoded in the first byte.
                memPtr := add(memPtr, 1) // skip over the first byte

                // right shift to the correct position
                dataLen := div(mload(memPtr), exp(256, sub(WORD_SIZE, lengthLen)))
                decodedLength := add(dataLen, add(lengthLen, 1))
                byte1 := byte(0, mload(memPtr))
            }

            // Check that the length has no leading zeros
            require(byte1 != 0, "Invalid leading zeros in length of the length for a long list");
            // Check that the value of length > MAX_SHORT_LEN
            require(dataLen > MAX_SHORT_LEN, "Invalid length for a long list");
            // Calculate the offset
            offset = lengthLen + 1;
        }

        return (decodedLength, offset);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/transactions/GenericTransaction.sol

pragma solidity 0.5.11;

/**
 * @title GenericTransaction
 * @notice GenericTransaction is a generic transaction format that makes few assumptions about the
 * content of the transaction. A transaction must satisy the following requirements:
 * - It must be a list of 5 items: [txType, inputs, outputs, txData, metaData]
 * - `txType` must be a uint not equal to zero
 * - inputs must be a list of RLP items.
 * - outputs must be a list of `Output`s
 * - an `Output` is a list of 2 items: [outputType, data]
 * - `Output.outputType` must be a uint not equal to zero
 * - `Output.data` is an RLP item. It can be a list.
 * - no assumptions are made about `txData`. Note that `txData` can be a list.
 * - `metaData` must be 32 bytes long.
 */
library GenericTransaction {

    uint8 constant private TX_NUM_ITEMS = 5;

    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    struct Transaction {
        uint256 txType;
        RLPReader.RLPItem[] inputs;
        Output[] outputs;
        RLPReader.RLPItem txData;
        bytes32 metaData;
    }

    struct Output {
        uint256 outputType;
        RLPReader.RLPItem data;
    }

    /**
    * @dev Decodes an RLP encoded transaction into the generic format.
    */
    function decode(bytes memory transaction) internal pure returns (Transaction memory) {
        RLPReader.RLPItem[] memory rlpTx = transaction.toRlpItem().toList();
        require(rlpTx.length == TX_NUM_ITEMS, "Invalid encoding of transaction");
        uint256 txType = rlpTx[0].toUint();
        require(txType > 0, "Transaction type must not be 0");

        RLPReader.RLPItem[] memory outputList = rlpTx[2].toList();
        Output[] memory outputs = new Output[](outputList.length);
        for (uint i = 0; i < outputList.length; i++) {
            outputs[i] = decodeOutput(outputList[i]);
        }

        bytes32 metaData = rlpTx[4].toBytes32();

        return Transaction({
            txType: txType,
            inputs: rlpTx[1].toList(),
            outputs: outputs,
            txData: rlpTx[3],
            metaData: metaData
        });
    }

    /**
    * @dev Returns the output at a specific index in the transaction
    */
    function getOutput(Transaction memory transaction, uint16 outputIndex)
        internal
        pure
        returns (Output memory)
    {
        require(outputIndex < transaction.outputs.length, "Output index out of bounds");
        return transaction.outputs[outputIndex];
    }

    /**
    * @dev Decodes an RLPItem to an output
    */
    function decodeOutput(RLPReader.RLPItem memory encodedOutput)
        internal
        pure
        returns (Output memory)
    {
        RLPReader.RLPItem[] memory rlpList = encodedOutput.toList();
        require(rlpList.length == 2, "Output must have 2 items");

        Output memory output = Output({
            outputType: rlpList[0].toUint(),
            data: rlpList[1]
        });

        require(output.outputType != 0, "Output type must not be 0");
        return output;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/transactions/FungibleTokenOutputModel.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;


/**
 * @notice Data structure and its decode function for ouputs of fungible token transactions
 */
library FungibleTokenOutputModel {
    using RLPReader for RLPReader.RLPItem;

    struct Output {
        uint256 outputType;
        bytes20 outputGuard;
        address token;
        uint256 amount;
    }

    /**
     * @notice Given a GenericTransaction.Output, decodes the `data` field.
     * The data field is an RLP list that must satisfy the following conditions:
     *      - It must have 3 elements: [`outputGuard`, `token`, `amount`]
     *      - `outputGuard` is a 20 byte long array
     *      - `token` is a 20 byte long array
     *      - `amount` must be an integer value with no leading zeros.
     * @param genericOutput A GenericTransaction.Output
     * @return A fully decoded FungibleTokenOutputModel.Output struct
     */
    function decodeOutput(GenericTransaction.Output memory genericOutput)
        internal
        pure
        returns (Output memory)
    {
        RLPReader.RLPItem[] memory dataList = genericOutput.data.toList();
        require(dataList.length == 3, "Output data must have 3 items");

        Output memory outputData = Output({
            outputType: genericOutput.outputType,
            outputGuard: bytes20(dataList[0].toAddress()),
            token: dataList[1].toAddress(),
            amount: dataList[2].toUint()
        });

        require(outputData.outputGuard != bytes20(0), "Output outputGuard must not be 0");
        return outputData;
    }

    /**
    * @dev Decodes and returns the output at a specific index in the transaction
    */
    function getOutput(GenericTransaction.Transaction memory transaction, uint16 outputIndex)
        internal
        pure
        returns
        (Output memory)
    {
        require(outputIndex < transaction.outputs.length, "Output index out of bounds");
        return decodeOutput(transaction.outputs[outputIndex]);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/transactions/PaymentTransactionModel.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;


/**
 * @notice Data structure and its decode function for Payment transaction
 */
library PaymentTransactionModel {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    uint8 constant private _MAX_INPUT_NUM = 5;
    uint8 constant private _MAX_OUTPUT_NUM = 5;

    uint8 constant private ENCODED_LENGTH = 4;

    // solhint-disable-next-line func-name-mixedcase
    function MAX_INPUT_NUM() internal pure returns (uint8) {
        return _MAX_INPUT_NUM;
    }

    // solhint-disable-next-line func-name-mixedcase
    function MAX_OUTPUT_NUM() internal pure returns (uint8) {
        return _MAX_OUTPUT_NUM;
    }

    struct Transaction {
        uint256 txType;
        bytes32[] inputs;
        FungibleTokenOutputModel.Output[] outputs;
        uint256 txData;
        bytes32 metaData;
    }

    /**
     * @notice Decodes a encoded byte array into a PaymentTransaction
     * The following rules about the rlp-encoded transaction are enforced:
     *      - `txType` must be an integer value with no leading zeros
     *      - `inputs` is an list of 0 to _MAX_INPUT_NUM elements
     *      - Each `input` is a 32 byte long array
     *      - An `input` may not be all zeros
     *      - `outputs` is an list of 0 to _MAX_OUTPUT_NUM elements
     *      - Each `output` is a list of 2 elements: [`outputType`, `data`]
     *      - `output.outputType` must be an integer value with no leading zeros
     *      - See FungibleTokenOutputModel for details on `output.data` encoding.
     * @param _tx An RLP-encoded transaction
     * @return A decoded PaymentTransaction struct
     */
    function decode(bytes memory _tx) internal pure returns (PaymentTransactionModel.Transaction memory) {
        return fromGeneric(GenericTransaction.decode(_tx));
    }

    /**
     * @notice Converts a GenericTransaction to a PaymentTransaction
     * @param genericTx A GenericTransaction.Transaction struct
     * @return A PaymentTransaction.Transaction struct
     */
    function fromGeneric(GenericTransaction.Transaction memory genericTx)
        internal
        pure
        returns (PaymentTransactionModel.Transaction memory)
    {
        require(genericTx.inputs.length <= _MAX_INPUT_NUM, "Transaction inputs num exceeds limit");
        require(genericTx.outputs.length != 0, "Transaction cannot have 0 outputs");
        require(genericTx.outputs.length <= _MAX_OUTPUT_NUM, "Transaction outputs num exceeds limit");

        bytes32[] memory inputs = new bytes32[](genericTx.inputs.length);
        for (uint i = 0; i < genericTx.inputs.length; i++) {
            bytes32 input = genericTx.inputs[i].toBytes32();
            require(uint256(input) != 0, "Null input not allowed");
            inputs[i] = input;
        }

        FungibleTokenOutputModel.Output[] memory outputs = new FungibleTokenOutputModel.Output[](genericTx.outputs.length);
        for (uint i = 0; i < genericTx.outputs.length; i++) {
            outputs[i] = FungibleTokenOutputModel.decodeOutput(genericTx.outputs[i]);
        }

        // txData is unused, it must be 0
        require(genericTx.txData.toUint() == 0, "txData must be 0");

        return Transaction({
            txType: genericTx.txType,
            inputs: inputs,
            outputs: outputs,
            txData: 0,
            metaData: genericTx.metaData
        });
    }

    /**
     * @notice Retrieve the 'owner' from the output, assuming the
     *         'outputGuard' field directly holds the owner's address
     */
    function getOutputOwner(FungibleTokenOutputModel.Output memory output) internal pure returns (address payable) {
        return address(uint160(output.outputGuard));
    }

    /**
     * @notice Gets output at provided index
     *
     */
    function getOutput(Transaction memory transaction, uint16 outputIndex) internal pure returns (FungibleTokenOutputModel.Output memory) {
        require(outputIndex < transaction.outputs.length, "Output index out of bounds");
        return transaction.outputs[outputIndex];
    }
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/payment/PaymentTransactionStateTransitionVerifier.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;




/**
* @notice Verifies state transitions for payment transaction
* @dev For payment transaction to be valid, the state transition should check that the sum of the inputs is larger than the sum of the outputs
*/
contract PaymentTransactionStateTransitionVerifier {
    using SafeMath for uint256;

    /**
     * @dev For payment transaction to be valid, the state transition should check that the sum of the inputs is larger than the sum of the outputs
     */
    function isCorrectStateTransition(
        bytes calldata txBytes,
        bytes[] calldata inputTxs,
        uint16[] calldata outputIndexOfInputTxs
    )
        external
        pure
        returns (bool)
    {
        if (inputTxs.length != outputIndexOfInputTxs.length) {
            return false;
        }

        FungibleTokenOutputModel.Output[] memory inputs = new FungibleTokenOutputModel.Output[](inputTxs.length);
        for (uint i = 0; i < inputTxs.length; i++) {
            uint16 outputIndex = outputIndexOfInputTxs[i];
            FungibleTokenOutputModel.Output memory output = FungibleTokenOutputModel.getOutput(
                GenericTransaction.decode(inputTxs[i]),
                outputIndex
            );
            inputs[i] = output;
        }

        PaymentTransactionModel.Transaction memory transaction = PaymentTransactionModel.decode(txBytes);
        FungibleTokenOutputModel.Output[] memory outputs = new FungibleTokenOutputModel.Output[](transaction.outputs.length);
        for (uint i = 0; i < transaction.outputs.length; i++) {
            outputs[i] = FungibleTokenOutputModel.Output(
                    transaction.outputs[i].outputType,
                    transaction.outputs[i].outputGuard,
                    transaction.outputs[i].token,
                    transaction.outputs[i].amount
                );
        }

        return _isCorrectStateTransition(inputs, outputs);
    }

    function _isCorrectStateTransition(
        FungibleTokenOutputModel.Output[] memory inputs,
        FungibleTokenOutputModel.Output[] memory outputs
    )
        private
        pure
        returns (bool)
    {
        bool correctTransition = true;
        uint i = 0;
        while (correctTransition && i < outputs.length) {
            address token = outputs[i].token;
            FungibleTokenOutputModel.Output[] memory inputsForToken = filterWithToken(inputs, token);
            FungibleTokenOutputModel.Output[] memory outputsForToken = filterWithToken(outputs, token);

            correctTransition = isCorrectSpend(inputsForToken, outputsForToken);
            i += 1;
        }
        return correctTransition;
    }

    function filterWithToken(
        FungibleTokenOutputModel.Output[] memory outputs,
        address token
    )
        private
        pure
        returns (FungibleTokenOutputModel.Output[] memory)
    {
        // Required for calculating the size of the filtered array
        uint256 arraySize = 0;
        for (uint i = 0; i < outputs.length; ++i) {
            if (outputs[i].token == token) {
                arraySize += 1;
            }
        }

        FungibleTokenOutputModel.Output[] memory outputsWithToken = new FungibleTokenOutputModel.Output[](arraySize);
        uint j = 0;
        for (uint i = 0; i < outputs.length; ++i) {
            if (outputs[i].token == token) {
                outputsWithToken[j] = outputs[i];
                j += 1;
            }
        }

        return outputsWithToken;
    }

    function isCorrectSpend(
        FungibleTokenOutputModel.Output[] memory inputs,
        FungibleTokenOutputModel.Output[] memory outputs
    )
        internal
        pure
        returns (bool)
    {
        uint256 amountIn = sumAmounts(inputs);
        uint256 amountOut = sumAmounts(outputs);
        return amountIn >= amountOut;
    }

    function sumAmounts(FungibleTokenOutputModel.Output[] memory outputs) private pure returns (uint256) {
        uint256 amount = 0;
        for (uint i = 0; i < outputs.length; i++) {
            amount = amount.add(outputs[i].amount);
        }
        return amount;
    }
}
