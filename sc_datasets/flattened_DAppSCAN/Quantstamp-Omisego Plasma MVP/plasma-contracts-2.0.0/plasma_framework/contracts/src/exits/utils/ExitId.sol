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

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/utils/PosLib.sol

pragma solidity 0.5.11;

/**
 * @dev UTXO position = (blknum * BLOCK_OFFSET + txIndex * TX_OFFSET + outputIndex).
 * TX position = (blknum * BLOCK_OFFSET + txIndex * TX_OFFSET)
 */
library PosLib {
    struct Position {
        uint64 blockNum;
        uint16 txIndex;
        uint16 outputIndex;
    }

    uint256 constant internal BLOCK_OFFSET = 1000000000;
    uint256 constant internal TX_OFFSET = 10000;

    uint256 constant internal MAX_OUTPUT_INDEX = TX_OFFSET - 1;
    // Since we are using a merkle tree of depth 16, max tx index size is 2^16 - 1
    uint256 constant internal MAX_TX_INDEX = 2 ** 16 - 1;
    // The maximum block number we can handle depends on ExitPriority. ExitPriority only uses 56 bits for blockNum + txIndex
    // This is 720575940379 blocks, which works out to be 342 years of blocks (given a block occurs every 15 seconds)
    uint256 constant internal MAX_BLOCK_NUM = ((2 ** 56 - 1) - MAX_TX_INDEX) / (BLOCK_OFFSET / TX_OFFSET);

    /**
     * @notice Returns transaction position which is an utxo position of zero index output
     * @param pos UTXO position of the output
     * @return Position of a transaction
     */
    function toStrictTxPos(Position memory pos)
        internal
        pure
        returns (Position memory)
    {
        return Position(pos.blockNum, pos.txIndex, 0);
    }

    /**
     * @notice Used for calculating exit priority
     * @param pos UTXO position for the output
     * @return Identifier of the transaction
     */
    function getTxPositionForExitPriority(Position memory pos)
        internal
        pure
        returns (uint56)
    {
        return uint56(encode(pos) / TX_OFFSET);
    }

    /**
     * @notice Encodes a position
     * @param pos Position
     * @return Position encoded as an integer
     */
    function encode(Position memory pos) internal pure returns (uint256) {
        require(pos.outputIndex <= MAX_OUTPUT_INDEX, "Invalid output index");
        require(pos.blockNum <= MAX_BLOCK_NUM, "Invalid block number");

        return pos.blockNum * BLOCK_OFFSET + pos.txIndex * TX_OFFSET + pos.outputIndex;
    }

    /**
     * @notice Decodes a position from an integer value
     * @param pos Encoded position
     * @return Position
     */
    function decode(uint256 pos) internal pure returns (Position memory) {
        uint256 blockNum = pos / BLOCK_OFFSET;
        uint256 txIndex = (pos % BLOCK_OFFSET) / TX_OFFSET;
        uint16 outputIndex = uint16(pos % TX_OFFSET);

        require(blockNum <= MAX_BLOCK_NUM, "blockNum exceeds max size allowed in PlasmaFramework");
        require(txIndex <= MAX_TX_INDEX, "txIndex exceeds the size of uint16");
        return Position(uint64(blockNum), uint16(txIndex), outputIndex);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/utils/OutputId.sol

pragma solidity 0.5.11;

library OutputId {
    /**
     * @notice Computes the output ID for a deposit tx
     * @dev Deposit tx bytes might not be unique because all inputs are empty
     *      Two deposits with the same output value would result in the same tx bytes
     *      As a result, we need to hash with utxoPos to ensure uniqueness
     * @param _txBytes Transaction bytes
     * @param _outputIndex Output index of the output
     * @param _utxoPosValue (Optional) UTXO position of the deposit output
     */
    function computeDepositOutputId(bytes memory _txBytes, uint256 _outputIndex, uint256 _utxoPosValue)
        internal
        pure
        returns(bytes32)
    {
        return keccak256(abi.encodePacked(_txBytes, _outputIndex, _utxoPosValue));
    }

    /**
     * @notice Computes the output ID for normal (non-deposit) tx
     * @dev Since txBytes for non-deposit tx is unique, directly hash the txBytes with outputIndex
     * @param _txBytes Transaction bytes
     * @param _outputIndex Output index of the output
     */
    function computeNormalOutputId(bytes memory _txBytes, uint256 _outputIndex)
        internal
        pure
        returns(bytes32)
    {
        return keccak256(abi.encodePacked(_txBytes, _outputIndex));
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-Omisego Plasma MVP/plasma-contracts-2.0.0/plasma_framework/contracts/src/exits/utils/ExitId.sol

pragma solidity 0.5.11;



library ExitId {
    using PosLib for PosLib.Position;
    using Bits for uint168;
    using Bits for uint256;

    uint8 constant private FIRST_BIT_LOCATION = 167;

    /**
     * @notice Checks whether exitId is a standard exit ID
     */
    function isStandardExit(uint168 exitId) internal pure returns (bool) {
        return exitId.getBit(FIRST_BIT_LOCATION) == 0;
    }

    /**
     * @notice Given transaction bytes and UTXO position, returns its exit ID
     * @dev Computation of a deposit ID is different to any other tx because txBytes of a deposit tx can be a non-unique value
     * @param isDeposit Defines whether the tx for the exitId is a deposit tx
     * @param txBytes Transaction bytes
     * @param utxoPos UTXO position of the exiting output
     * @return standardExitId Unique ID of the standard exit
     *     Anatomy of returned value, most significant bits first:
     *     1-bit - in-flight flag (0 for standard exit)
     *     167-bits - outputId
     */
    function getStandardExitId(
        bool isDeposit,
        bytes memory txBytes,
        PosLib.Position memory utxoPos
    )
        internal
        pure
        returns (uint168)
    {
        bytes32 outputId;
        if (isDeposit) {
            outputId = OutputId.computeDepositOutputId(txBytes, utxoPos.outputIndex, utxoPos.encode());
        } else {
            outputId = OutputId.computeNormalOutputId(txBytes, utxoPos.outputIndex);
        }

        return uint168((uint256(outputId) >> (256 - FIRST_BIT_LOCATION)));
    }

    /**
    * @notice Given transaction bytes, returns in-flight exit ID
    * @param txBytes Transaction bytes
    * @return Unique in-flight exit ID
    */
    function getInFlightExitId(bytes memory txBytes) internal pure returns (uint168) {
        return uint168((uint256(keccak256(txBytes)) >> (256 - FIRST_BIT_LOCATION)).setBit(FIRST_BIT_LOCATION));
    }
}
