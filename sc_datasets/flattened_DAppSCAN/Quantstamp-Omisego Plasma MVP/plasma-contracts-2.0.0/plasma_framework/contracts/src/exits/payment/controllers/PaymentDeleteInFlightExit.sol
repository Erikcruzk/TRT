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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/utils/Bits.sol

pragma solidity 0.5.11;

/**
 * @title Bits
 * @dev Operations on individual bits of a word
 */
library Bits {
    /*
     * Storage
     */

    uint constant internal ONE = uint(1);

    /*
     * Internal functions
     */
    /**
     * @dev Sets the bit at the given '_index' in '_self' to '1'
     * @param _self Uint to modify
     * @param _index Index of the bit to set
     * @return The modified value
     */
    function setBit(uint _self, uint8 _index)
        internal
        pure
        returns (uint)
    {
        return _self | ONE << _index;
    }

    /**
     * @dev Sets the bit at the given '_index' in '_self' to '0'
     * @param _self Uint to modify
     * @param _index Index of the bit to set
     * @return The modified value
     */
    function clearBit(uint _self, uint8 _index)
        internal
        pure
        returns (uint)
    {
        return _self & ~(ONE << _index);
    }

    /**
     * @dev Returns the bit at the given '_index' in '_self'
     * @param _self Uint to check
     * @param _index Index of the bit to retrieve
     * @return The value of the bit at '_index'
     */
    function getBit(uint _self, uint8 _index)
        internal
        pure
        returns (uint8)
    {
        return uint8(_self >> _index & 1);
    }

    /**
     * @dev Checks if the bit at the given '_index' in '_self' is '1'
     * @param _self Uint to check
     * @param _index Index of the bit to check
     * @return True, if the bit is '0'; otherwise, False
     */
    function bitSet(uint _self, uint8 _index)
        internal
        pure
        returns (bool)
    {
        return getBit(_self, _index) == 1;
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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/payment/PaymentInFlightExitModelUtils.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;



library PaymentInFlightExitModelUtils {
    using Bits for uint256;

    function isInputEmpty(ExitModel.InFlightExit memory ife, uint16 index)
        internal
        pure
        returns (bool)
    {
        require(index < PaymentTransactionModel.MAX_INPUT_NUM(), "Invalid input index");
        return isEmptyWithdrawData(ife.inputs[index]);
    }

    function isOutputEmpty(ExitModel.InFlightExit memory ife, uint16 index)
        internal
        pure
        returns (bool)
    {
        require(index < PaymentTransactionModel.MAX_OUTPUT_NUM(), "Invalid output index");
        return isEmptyWithdrawData(ife.outputs[index]);
    }

    function isInputPiggybacked(ExitModel.InFlightExit memory ife, uint16 index)
        internal
        pure
        returns (bool)
    {
        require(index < PaymentTransactionModel.MAX_INPUT_NUM(), "Invalid input index");
        return ife.exitMap.bitSet(uint8(index));
    }

    function isOutputPiggybacked(ExitModel.InFlightExit memory ife, uint16 index)
        internal
        pure
        returns (bool)
    {
        require(index < PaymentTransactionModel.MAX_OUTPUT_NUM(), "Invalid output index");
        uint8 indexInExitMap = uint8(index + PaymentTransactionModel.MAX_INPUT_NUM());
        return ife.exitMap.bitSet(indexInExitMap);
    }

    function setInputPiggybacked(ExitModel.InFlightExit storage ife, uint16 index)
        internal
    {
        require(index < PaymentTransactionModel.MAX_INPUT_NUM(), "Invalid input index");
        ife.exitMap = ife.exitMap.setBit(uint8(index));
    }

    function clearInputPiggybacked(ExitModel.InFlightExit storage ife, uint16 index)
        internal
    {
        require(index < PaymentTransactionModel.MAX_INPUT_NUM(), "Invalid input index");
        ife.exitMap = ife.exitMap.clearBit(uint8(index));
    }

    function setOutputPiggybacked(ExitModel.InFlightExit storage ife, uint16 index)
        internal
    {
        require(index < PaymentTransactionModel.MAX_OUTPUT_NUM(), "Invalid output index");
        uint8 indexInExitMap = uint8(index + PaymentTransactionModel.MAX_INPUT_NUM());
        ife.exitMap = ife.exitMap.setBit(indexInExitMap);
    }

    function clearOutputPiggybacked(ExitModel.InFlightExit storage ife, uint16 index)
        internal
    {
        require(index < PaymentTransactionModel.MAX_OUTPUT_NUM(), "Invalid output index");
        uint8 indexInExitMap = uint8(index + PaymentTransactionModel.MAX_INPUT_NUM());
        ife.exitMap = ife.exitMap.clearBit(indexInExitMap);
    }

    function isInFirstPhase(ExitModel.InFlightExit memory ife, uint256 minExitPeriod)
        internal
        view
        returns (bool)
    {
        uint256 periodTime = minExitPeriod / 2;
        return ((block.timestamp - ife.exitStartTimestamp) / periodTime) < 1;
    }

    function isEmptyWithdrawData(ExitModel.WithdrawData memory data) private pure returns (bool) {
        return data.outputId == bytes32("") &&
                data.exitTarget == address(0) &&
                data.token == address(0) &&
                data.amount == 0 &&
                data.piggybackBondSize == 0;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/utils/SafeEthTransfer.sol

pragma solidity 0.5.11;

/**
* @notice Utility library to safely transfer ETH
* @dev transfer is no longer the recommended way to do ETH transfer.
*      see issue: https://github.com/omisego/plasma-contracts/issues/312
*
*      This library limits the amount of gas used for external calls with value to protect against potential DOS/griefing attacks that try to use up all the gas.
*      see issue: https://github.com/omisego/plasma-contracts/issues/385
*/
library SafeEthTransfer {
    /**
     * @notice Try to transfer eth without using more gas than `gasStipend`.
     *         Reverts if it fails to transfer the ETH.
     * @param receiver the address to receive ETH
     * @param amount the amount of ETH (in wei) to transfer
     * @param gasStipend the maximum amount of gas to be used for the call
     */
    function transferRevertOnError(address payable receiver, uint256 amount, uint256 gasStipend)
        internal
    {
        bool success = transferReturnResult(receiver, amount, gasStipend);
        require(success, "SafeEthTransfer: failed to transfer ETH");
    }

    /**
     * @notice Transfer ETH without using more gas than the `gasStipend`.
     *         Returns whether the transfer call is successful or not.
     * @dev EVM will revert with "out of gas" error if there is not enough gas left for the call
     * @param receiver the address to receive ETH
     * @param amount the amount of ETH (in wei) to transfer
     * @param gasStipend the maximum amount of gas to be used during the transfer call
     * @return a flag showing the call is successful or not
     */
    function transferReturnResult(address payable receiver, uint256 amount, uint256 gasStipend)
        internal
        returns (bool)
    {
        (bool success, ) = receiver.call.gas(gasStipend).value(amount)("");
        return success;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/payment/controllers/PaymentDeleteInFlightExit.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;




library PaymentDeleteInFlightExit {
    using PaymentInFlightExitModelUtils for PaymentExitDataModel.InFlightExit;

    struct Controller {
        uint256 minExitPeriod;
        uint256 safeGasStipend;
    }

    event InFlightExitDeleted(
        uint168 indexed exitId
    );

    /**
     * @notice Main logic function to delete the non piggybacked in-flight exit
     * @param exitId The exitId of the standard exit
     */
    function run(
        Controller memory self,
        PaymentExitDataModel.InFlightExitMap storage exitMap,
        uint168 exitId
    )
        public
    {
        PaymentExitDataModel.InFlightExit memory ife = exitMap.exits[exitId];
        require(ife.exitStartTimestamp != 0, "In-flight exit does not exist");
        require(!ife.isInFirstPhase(self.minExitPeriod), "Cannot delete in-flight exit still in first phase");
        require(!isPiggybacked(ife), "The in-flight exit is already piggybacked");

        delete exitMap.exits[exitId];
        SafeEthTransfer.transferRevertOnError(ife.bondOwner, ife.bondSize, self.safeGasStipend);
        emit InFlightExitDeleted(exitId);
    }

    function isPiggybacked(ExitModel.InFlightExit memory ife)
        private
        pure
        returns (bool)
    {
        for (uint16 i = 0; i < PaymentTransactionModel.MAX_INPUT_NUM(); i++) {
            if (ife.isInputPiggybacked(i)) {
                return true;
            }
        }

        for (uint16 i = 0; i < PaymentTransactionModel.MAX_OUTPUT_NUM(); i++) {
            if (ife.isOutputPiggybacked(i)) {
                return true;
            }
        }

        return false;
    }
}
