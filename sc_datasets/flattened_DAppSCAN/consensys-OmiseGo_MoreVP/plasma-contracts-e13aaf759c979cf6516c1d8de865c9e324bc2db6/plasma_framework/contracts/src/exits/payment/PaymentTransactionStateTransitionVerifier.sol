// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/exits/interfaces/IStateTransitionVerifier.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/exits/payment/PaymentExitDataModel.sol

pragma solidity 0.5.11;

/**
 * @notice Model library for PaymentExit
 */
library PaymentExitDataModel {
    uint8 constant public MAX_INPUT_NUM = 4;
    uint8 constant public MAX_OUTPUT_NUM = 4;

    /**
     * @dev Exit model for a standard exit
     * @param exitable Boolean that defines whether exit is possible. Used by the challenge game to flag the result.
     * @param utxoPos The UTXO position of the transaction's exiting output
     * @param outputId The output identifier, in OutputId format
     * @param exitTarget The address to which the exit withdraws funds
     * @param amount The amount of funds to withdraw with this exit
     * @param bondSize The size of the bond put up for this exit to start, and which is used to cover the cost of challenges
     */
    struct StandardExit {
        bool exitable;
        uint192 utxoPos;
        bytes32 outputId;
        address payable exitTarget;
        uint256 amount;
        uint256 bondSize;
    }

    /**
     * @dev Mapping of (exitId => StandardExit) that stores all standard exit data
     */
    struct StandardExitMap {
        mapping (uint192 => PaymentExitDataModel.StandardExit) exits;
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
        mapping (uint160 => PaymentExitDataModel.InFlightExit) exits;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/utils/TxPosLib.sol

pragma solidity 0.5.11;

/**
 * @dev Transaction position = (blockNumber * BLOCK_OFFSET_FOR_TX_POS + txIndex)
 */
library TxPosLib {
    struct TxPos {
        uint256 value;
    }

    uint256 constant internal BLOCK_OFFSET_FOR_TX_POS = 1000000000 / 10000;

    /**
     * @notice Returns the block number for a given a tx position
     * @param _txPos Position of the transaction
     * @return Block number of the output
     */
    function blockNum(TxPos memory _txPos)
        internal
        pure
        returns (uint256)
    {
        return _txPos.value / BLOCK_OFFSET_FOR_TX_POS;
    }

    /**
     * @notice Returns the transaction index for a given tx position
     * @param _txPos Position of the transaction
     * @return Transaction index of the output
     */
    function txIndex(TxPos memory _txPos)
        internal
        pure
        returns (uint256)
    {
        return _txPos.value % BLOCK_OFFSET_FOR_TX_POS;
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

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/utils/UtxoPosLib.sol

pragma solidity 0.5.11;

/**
 * @dev UTXO position = (blockNumber * BLOCK_OFFSET + txIndex * TX_OFFSET + outputIndex).
 */
library UtxoPosLib {
    using SafeMath for uint256;

    struct UtxoPos {
        uint256 value;
    }

    uint256 constant internal BLOCK_OFFSET = 1000000000;
    uint256 constant internal TX_OFFSET = 10000;

    /**
     * @notice Returns the UTXO struct for a given txPos and outputIndex
     * @param txPos Transaction position
     * @param outputIndex Transaction index of the output
     * @return UtxoPos of the relevant value
     */
    function build(TxPosLib.TxPos memory txPos, uint16 outputIndex)
        internal
        pure
        returns (UtxoPos memory)
    {
        return UtxoPos(txPos.value.mul(TX_OFFSET).add(outputIndex));
    }

    /**
     * @notice Returns the block number of a given UTXO position
     * @param _utxoPos UTXO position identifier for the output
     * @return The block number of the output
     */
    function blockNum(UtxoPos memory _utxoPos)
        internal
        pure
        returns (uint256)
    {
        return _utxoPos.value / BLOCK_OFFSET;
    }

    /**
     * @notice Returns the transaction index of a given UTXO position
     * @param _utxoPos UTXO position identifier for the output
     * @return Transaction index of the output
     */
    function txIndex(UtxoPos memory _utxoPos)
        internal
        pure
        returns (uint256)
    {
        return (_utxoPos.value % BLOCK_OFFSET) / TX_OFFSET;
    }

    /**
     * @notice Returns the output index of a given UTXO position
     * @param _utxoPos UTXO position identifier for the output
     * @return Index of the output
     */
    function outputIndex(UtxoPos memory _utxoPos)
        internal
        pure
        returns (uint16)
    {
        return uint16(_utxoPos.value % TX_OFFSET);
    }

    /**
     * @notice Returns the transaction position of a given UTXO position
     * @param _utxoPos UTXO position identifier for the output
     * @return Position of the transaction
     */
    function txPos(UtxoPos memory _utxoPos)
        internal
        pure
        returns (TxPosLib.TxPos memory)
    {
        return TxPosLib.TxPos(_utxoPos.value / TX_OFFSET);
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/utils/RLPReader.sol

/*
* @author Hamdi Allam hamdi.allam97@gmail.com
* Please reach out with any questions or concerns
*/
pragma solidity ^0.5.0;

library RLPReader {
    uint8 constant internal STRING_SHORT_START = 0x80;
    uint8 constant internal STRING_LONG_START  = 0xb8;
    uint8 constant internal LIST_SHORT_START   = 0xc0;
    uint8 constant internal LIST_LONG_START    = 0xf8;
    uint8 constant internal MAX_SHORT_LEN      = 55;
    uint8 constant internal WORD_SIZE = 32;

    struct RLPItem {
        uint len;
        uint memPtr;
    }

    /*
    * @param item RLP encoded bytes
    */
    function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
        uint memPtr;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            memPtr := add(item, 0x20)
        }

        return RLPItem(item.length, memPtr);
    }

    /*
    * @param item RLP encoded list in bytes
    */
    function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
        require(isList(item), "Item is not a list");

        uint itemLen = _itemLength(item.memPtr);
        require(itemLen <= item.len, "Length is larger than data");

        uint items = numItems(item);
        RLPItem[] memory result = new RLPItem[](items);

        uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
        uint dataLen;
        uint lengthSum;
        for (uint i = 0; i < items; i++) {
            dataLen = _itemLength(memPtr);
            lengthSum += dataLen;
            require(lengthSum < item.len, "Invalid rlp item length");
            result[i] = RLPItem(dataLen, memPtr);
            memPtr = memPtr + dataLen;
        }

        return result;
    }

    // @return indicator whether encoded payload is a list. negate this function call for isData.
    function isList(RLPItem memory item) internal pure returns (bool) {
        if (item.len == 0) return false;

        uint8 byte0;
        uint memPtr = item.memPtr;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            byte0 := byte(0, mload(memPtr))
        }

        if (byte0 < LIST_SHORT_START)
            return false;
        return true;
    }

    /** RLPItem conversions into data types **/
    // @returns raw rlp encoding in bytes
    function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
        bytes memory result = new bytes(item.len);
        if (result.length == 0) return result;
        
        uint ptr;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            ptr := add(0x20, result)
        }

        copy(item.memPtr, ptr, item.len);
        return result;
    }

    function toAddress(RLPItem memory item) internal pure returns (address) {
        // 1 byte for the length prefix
        require(item.len == 21, "Item length must be == 21");

        return address(toUint(item));
    }

    function toUint(RLPItem memory item) internal pure returns (uint) {
        require(item.len > 0 && item.len <= 33, "Item length must be <= 33");
        
        uint itemLen = _itemLength(item.memPtr);
        require(itemLen <= item.len, "Length is larger than data");

        uint offset = _payloadOffset(item.memPtr);
        uint len = itemLen - offset;

        uint result;
        uint memPtr = item.memPtr + offset;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            result := mload(memPtr)

            // shfit to the correct location if neccesary
            // TODO audit prep, can this overflow?
            if lt(len, 32) {
                result := div(result, exp(256, sub(32, len)))
            }
        }

        return result;
    }

    /*
    * Private Helpers
    */
    // @return number of payload items inside an encoded list.
    function numItems(RLPItem memory item) private pure returns (uint) {
        if (item.len == 0) return 0;

        uint count = 0;
        uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
        uint endPtr = item.memPtr + item.len;
        while (currPtr < endPtr) {
            currPtr = currPtr + _itemLength(currPtr); // skip over an item
            require(currPtr <= endPtr, "Invalid rlp item length");
            count++;
        }

        return count;
    }

    // @return entire rlp item byte length
    function _itemLength(uint memPtr) private pure returns (uint) {
        uint itemLen;
        uint byte0;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            byte0 := byte(0, mload(memPtr))
        }

        if (byte0 < STRING_SHORT_START) {
            itemLen = 1;
        } else if (byte0 < STRING_LONG_START) {
            itemLen = byte0 - STRING_SHORT_START + 1;
            uint byte1;
            // solhint-disable-next-line no-inline-assembly
            assembly {
                memPtr := add(memPtr, 1)
                byte1 := byte(0, mload(memPtr))
            }
            if (itemLen == 2) {
                // Check that the value is valid for a short string
                require(byte1 >= STRING_SHORT_START, "Invalid rlp encoding");
            }
        } else if (byte0 < LIST_SHORT_START) {
            uint dataLen;
            uint byte1;
            // solhint-disable-next-line no-inline-assembly
            assembly {
                let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
                memPtr := add(memPtr, 1) // skip over the first byte

                byte1 := byte(0, mload(memPtr))
                
                /* 32 byte word size */
                // TODO audit prep, check this shifting for overflow, etc
                dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
                itemLen := add(dataLen, add(byteLen, 1))
            }
            // Check valid long string i.e. value of length > MAX_SHORT_LEN with no leading zeros
            require(byte1 != 0, "Invalid rlp encoding");
            require(dataLen > MAX_SHORT_LEN, "Invalid rlp encoding");
        } else if (byte0 < LIST_LONG_START) {
            itemLen = byte0 - LIST_SHORT_START + 1;
        } else {
            uint dataLen;
            uint byte1;
            // solhint-disable-next-line no-inline-assembly
            assembly {
                let lengthLen := sub(byte0, 0xf7)
                memPtr := add(memPtr, 1)

                byte1 := byte(0, mload(memPtr))

                // TODO audit prep, check this shifting for overflow, etc
                dataLen := div(mload(memPtr), exp(256, sub(32, lengthLen))) // right shifting to the correct length
                itemLen := add(dataLen, add(lengthLen, 1))
            }
            // Check valid long list i.e. value of length > MAX_SHORT_LEN with no leading zeros
            require(byte1 != 0, "Invalid rlp encoding");
            require(dataLen > MAX_SHORT_LEN, "Invalid rlp encoding");
        }

        return itemLen;
    }

    // @return number of bytes until the data
    function _payloadOffset(uint memPtr) private pure returns (uint) {
        uint byte0;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            byte0 := byte(0, mload(memPtr))
        }

        if (byte0 < STRING_SHORT_START) {
            return 0;
        } else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START)) {
            return 1;
        } else if (byte0 < LIST_SHORT_START) {  // being explicit
            return byte0 - (STRING_LONG_START - 1) + 1;
        } else {
            return byte0 - (LIST_LONG_START - 1) + 1;
        } 
    }

    /*
    * @param src Pointer to source
    * @param dest Pointer to destination
    * @param len Amount of memory to copy from the source
    */
    function copy(uint src, uint dest, uint len) private pure {
        if (len == 0) return;

        // copy as many word sizes as possible
        for (; len >= WORD_SIZE; len -= WORD_SIZE) {
            // solhint-disable-next-line no-inline-assembly
            assembly {
                mstore(dest, mload(src))
            }

            src += WORD_SIZE;
            dest += WORD_SIZE;
        }

        // left over bytes. Mask is used to remove unwanted bytes from the word
        uint mask = 256 ** (WORD_SIZE - len) - 1;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let srcpart := and(mload(src), not(mask)) // zero out src
            let destpart := and(mload(dest), mask) // retrieve the bytes
            mstore(dest, or(destpart, srcpart))
        }
    }

    function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
        require(item.len > 0, "Item length must be > 0");

        uint itemLen = _itemLength(item.memPtr);
        require(itemLen <= item.len, "Length is larger than data");

        uint offset = _payloadOffset(item.memPtr);
        uint len = itemLen - offset; // data length
        bytes memory result = new bytes(len);

        uint destPtr;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            destPtr := add(0x20, result)
        }

        copy(item.memPtr + offset, destPtr, len);
        return result;
    }

}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/transactions/WireTransaction.sol

pragma solidity 0.5.11;

/**
 * @title WireTransaction
 * @dev Utility functions for working with transactions in wire format, assuming our transactions have specified data structure limitations
 *      We assume that the current transaction structure supports transactions related to payment and DEX.
 *      Alternatively, it's possible to upgrade to a new ExitGame, using either an alternative transaction data structure, or interfaces
 */
library WireTransaction {

    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    struct Output {
        uint256 outputType;
        uint256 amount;
        bytes20 outputGuard;
        address token;
    }

    /**
    * @dev Returns output for transaction in wire format
    * Outputs is a field on the second index that should be a list with the following first three elements: amount, output guard, token
    */
    function getOutput(bytes memory transaction, uint16 outputIndex) internal pure returns (Output memory) {
        RLPReader.RLPItem[] memory rlpTx = transaction.toRlpItem().toList();
        RLPReader.RLPItem[] memory outputs = rlpTx[2].toList();
        require(outputIndex < outputs.length, "Invalid wire transaction format");

        RLPReader.RLPItem[] memory output = outputs[outputIndex].toList();
        uint256 outputType = output[0].toUint();
        bytes20 outputGuard = bytes20(output[1].toAddress());
        address token = output[2].toAddress();
        uint256 amount = output[3].toUint();

        return Output(outputType, amount, outputGuard, token);
    }

    /**
    * @dev Returns a transaction type for transaction, in wire format
    * Transaction type is the value of the first field in RLP-encoded list
    */
    function getTransactionType(bytes memory transaction) internal pure returns (uint256) {
        RLPReader.RLPItem[] memory rlpTx = transaction.toRlpItem().toList();
        return rlpTx[0].toUint();
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/utils/AddressPayable.sol

pragma solidity 0.5.11;

library AddressPayable {

    /**
     * @notice Converts an `address` into `address payable`
     * @dev Note that this is simply a type cast; the actual underlying value remains the same
     */
    function convert(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/transactions/outputs/PaymentOutputModel.sol

pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;


/**
 * @notice Data structure and its decode function for payment output
 */
library PaymentOutputModel {

    using RLPReader for RLPReader.RLPItem;

    struct Output {
        uint256 outputType;
        bytes20 outputGuard;
        address token;
        uint256 amount;
    }

    /**
     * @notice Retrieve the 'owner' from the output, assuming the 
     *         'outputGuard' field directly holds the owner's address
     * @dev It's possible that 'outputGuard' can be a hash of preimage that holds the owner information,
     *       but this should not and cannot be handled here.
     */
    function owner(Output memory _output) internal pure returns (address payable) {
        return AddressPayable.convert(address(uint160(_output.outputGuard)));
    }

    function decode(RLPReader.RLPItem memory encoded) internal pure returns (Output memory) {
        RLPReader.RLPItem[] memory rlpEncoded = encoded.toList();
        require(rlpEncoded.length == 4, "Invalid output encoding");

        Output memory output = Output({
            outputType: rlpEncoded[0].toUint(),
            outputGuard: bytes20(rlpEncoded[1].toAddress()),
            token: rlpEncoded[2].toAddress(),
            amount: rlpEncoded[3].toUint()
        });

        return output;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/transactions/PaymentTransactionModel.sol

pragma solidity 0.5.11;


/**
 * @notice Data structure and its decode function for Payment transaction
 */
library PaymentTransactionModel {

    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;
    using PaymentOutputModel for PaymentOutputModel.Output;

    uint8 constant public MAX_INPUT_NUM = 4;
    uint8 constant public MAX_OUTPUT_NUM = 4;

    uint8 constant private ENCODED_LENGTH = 4;

    struct Transaction {
        uint256 txType;
        bytes32[] inputs;
        PaymentOutputModel.Output[] outputs;
        bytes32 metaData;
    }

    function decode(bytes memory _tx) internal pure returns (PaymentTransactionModel.Transaction memory) {
        RLPReader.RLPItem[] memory rlpTx = _tx.toRlpItem().toList();
        require(rlpTx.length == ENCODED_LENGTH, "Invalid encoding of transaction");

        RLPReader.RLPItem[] memory rlpInputs = rlpTx[1].toList();
        require(rlpInputs.length <= MAX_INPUT_NUM, "Transaction inputs num exceeds limit");

        RLPReader.RLPItem[] memory rlpOutputs = rlpTx[2].toList();
        require(rlpOutputs.length <= MAX_OUTPUT_NUM, "Transaction outputs num exceeds limit");

        uint txType = rlpTx[0].toUint();

        bytes32[] memory inputs = new bytes32[](rlpInputs.length);
        for (uint i = 0; i < rlpInputs.length; i++) {
            bytes32 input = bytes32(rlpInputs[i].toUint());
            inputs[i] = input;
        }

        PaymentOutputModel.Output[] memory outputs = new PaymentOutputModel.Output[](rlpOutputs.length);
        for (uint i = 0; i < rlpOutputs.length; i++) {
            PaymentOutputModel.Output memory output = PaymentOutputModel.decode(rlpOutputs[i]);
            outputs[i] = output;
        }

        bytes32 metaData = bytes32(rlpTx[3].toUint());

        return Transaction({txType: txType, inputs: inputs, outputs: outputs, metaData: metaData});
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-OmiseGo_MoreVP/plasma-contracts-e13aaf759c979cf6516c1d8de865c9e324bc2db6/plasma_framework/contracts/src/exits/payment/PaymentTransactionStateTransitionVerifier.sol

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

        WireTransaction.Output[] memory inputs = new WireTransaction.Output[](inputTxs.length);
        for (uint i = 0; i < inputTxs.length; i++) {
            uint16 outputIndex = outputIndexOfInputTxs[i];
            WireTransaction.Output memory output = WireTransaction.getOutput(inputTxs[i], outputIndex);
            inputs[i] = output;
        }

        PaymentTransactionModel.Transaction memory transaction = PaymentTransactionModel.decode(txBytes);
        WireTransaction.Output[] memory outputs = new WireTransaction.Output[](transaction.outputs.length);
        for (uint i = 0; i < transaction.outputs.length; i++) {
            outputs[i] = WireTransaction.Output(
                    transaction.outputs[i].outputType,
                    transaction.outputs[i].amount,
                    transaction.outputs[i].outputGuard,
                    transaction.outputs[i].token
                );
        }

        return _isCorrectStateTransition(inputs, outputs);
    }

    function _isCorrectStateTransition(
        WireTransaction.Output[] memory inputs,
        WireTransaction.Output[] memory outputs
    )
        private
        pure
        returns (bool)
    {
        bool correctTransition = true;
        uint i = 0;
        while (correctTransition && i < outputs.length) {
            address token = outputs[i].token;
            WireTransaction.Output[] memory inputsForToken = filterWithToken(inputs, token);
            WireTransaction.Output[] memory outputsForToken = filterWithToken(outputs, token);

            correctTransition = isCorrectSpend(inputsForToken, outputsForToken);
            i += 1;
        }
        return correctTransition;
    }

    function filterWithToken(
        WireTransaction.Output[] memory outputs,
        address token
    )
        private
        pure
        returns (WireTransaction.Output[] memory)
    {
        // Required for calculating the size of the filtered array
        uint256 arraySize = 0;
        for (uint i = 0; i < outputs.length; ++i) {
            if (outputs[i].token == token) {
                arraySize += 1;
            }
        }

        WireTransaction.Output[] memory outputsWithToken = new WireTransaction.Output[](arraySize);
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
        WireTransaction.Output[] memory inputs,
        WireTransaction.Output[] memory outputs
    )
        internal
        pure
        returns (bool)
    {
        uint256 amountIn = sumAmounts(inputs);
        uint256 amountOut = sumAmounts(outputs);
        return amountIn >= amountOut;
    }

    function sumAmounts(WireTransaction.Output[] memory outputs) private pure returns (uint256) {
        uint256 amount = 0;
        for (uint i = 0; i < outputs.length; i++) {
            amount = amount.add(outputs[i].amount);
        }
        return amount;
    }
}