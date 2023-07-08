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

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/common/FixidityLib.sol

pragma solidity ^0.5.13;

/**
 * @title FixidityLib
 * @author Gadi Guy, Alberto Cuesta Canada
 * @notice This library provides fixed point arithmetic with protection against
 * overflow.
 * All operations are done with uint256 and the operands must have been created
 * with any of the newFrom* functions, which shift the comma digits() to the
 * right and check for limits, or with wrap() which expects a number already
 * in the internal representation of a fraction.
 * When using this library be sure to use maxNewFixed() as the upper limit for
 * creation of fixed point numbers.
 * @dev All contained functions are pure and thus marked internal to be inlined
 * on consuming contracts at compile time for gas efficiency.
 */
library FixidityLib {
  struct Fraction {
    uint256 value;
  }

  /**
   * @notice Number of positions that the comma is shifted to the right.
   */
  function digits() internal pure returns (uint8) {
    return 24;
  }

  uint256 private constant FIXED1_UINT = 1000000000000000000000000;

  /**
   * @notice This is 1 in the fixed point units used in this library.
   * @dev Test fixed1() equals 10^digits()
   * Hardcoded to 24 digits.
   */
  function fixed1() internal pure returns (Fraction memory) {
    return Fraction(FIXED1_UINT);
  }

  /**
   * @notice Wrap a uint256 that represents a 24-decimal fraction in a Fraction
   * struct.
   * @param x Number that already represents a 24-decimal fraction.
   * @return A Fraction struct with contents x.
   */
  function wrap(uint256 x) internal pure returns (Fraction memory) {
    return Fraction(x);
  }

  /**
   * @notice Unwraps the uint256 inside of a Fraction struct.
   */
  function unwrap(Fraction memory x) internal pure returns (uint256) {
    return x.value;
  }

  /**
   * @notice The amount of decimals lost on each multiplication operand.
   * @dev Test mulPrecision() equals sqrt(fixed1)
   */
  function mulPrecision() internal pure returns (uint256) {
    return 1000000000000;
  }

  /**
   * @notice Maximum value that can be converted to fixed point. Optimize for deployment.
   * @dev
   * Test maxNewFixed() equals maxUint256() / fixed1()
   */
  function maxNewFixed() internal pure returns (uint256) {
    return 115792089237316195423570985008687907853269984665640564;
  }

  /**
   * @notice Converts a uint256 to fixed point Fraction
   * @dev Test newFixed(0) returns 0
   * Test newFixed(1) returns fixed1()
   * Test newFixed(maxNewFixed()) returns maxNewFixed() * fixed1()
   * Test newFixed(maxNewFixed()+1) fails
   */
  function newFixed(uint256 x) internal pure returns (Fraction memory) {
    require(x <= maxNewFixed(), "can't create fixidity number larger than maxNewFixed()");
    return Fraction(x * FIXED1_UINT);
  }

  /**
   * @notice Converts a uint256 in the fixed point representation of this
   * library to a non decimal. All decimal digits will be truncated.
   */
  function fromFixed(Fraction memory x) internal pure returns (uint256) {
    return x.value / FIXED1_UINT;
  }

  /**
   * @notice Converts two uint256 representing a fraction to fixed point units,
   * equivalent to multiplying dividend and divisor by 10^digits().
   * @param numerator numerator must be <= maxNewFixed()
   * @param denominator denominator must be <= maxNewFixed() and denominator can't be 0
   * @dev
   * Test newFixedFraction(1,0) fails
   * Test newFixedFraction(0,1) returns 0
   * Test newFixedFraction(1,1) returns fixed1()
   * Test newFixedFraction(1,fixed1()) returns 1
   */
  function newFixedFraction(uint256 numerator, uint256 denominator)
    internal
    pure
    returns (Fraction memory)
  {
    Fraction memory convertedNumerator = newFixed(numerator);
    Fraction memory convertedDenominator = newFixed(denominator);
    return divide(convertedNumerator, convertedDenominator);
  }

  /**
   * @notice Returns the integer part of a fixed point number.
   * @dev
   * Test integer(0) returns 0
   * Test integer(fixed1()) returns fixed1()
   * Test integer(newFixed(maxNewFixed())) returns maxNewFixed()*fixed1()
   */
  function integer(Fraction memory x) internal pure returns (Fraction memory) {
    return Fraction((x.value / FIXED1_UINT) * FIXED1_UINT); // Can't overflow
  }

  /**
   * @notice Returns the fractional part of a fixed point number.
   * In the case of a negative number the fractional is also negative.
   * @dev
   * Test fractional(0) returns 0
   * Test fractional(fixed1()) returns 0
   * Test fractional(fixed1()-1) returns 10^24-1
   */
  function fractional(Fraction memory x) internal pure returns (Fraction memory) {
    return Fraction(x.value - (x.value / FIXED1_UINT) * FIXED1_UINT); // Can't overflow
  }

  /**
   * @notice x+y.
   * @dev The maximum value that can be safely used as an addition operator is defined as
   * maxFixedAdd = maxUint256()-1 / 2, or
   * 57896044618658097711785492504343953926634992332820282019728792003956564819967.
   * Test add(maxFixedAdd,maxFixedAdd) equals maxFixedAdd + maxFixedAdd
   * Test add(maxFixedAdd+1,maxFixedAdd+1) throws
   */
  function add(Fraction memory x, Fraction memory y) internal pure returns (Fraction memory) {
    uint256 z = x.value + y.value;
    require(z >= x.value, "add overflow detected");
    return Fraction(z);
  }

  /**
   * @notice x-y.
   * @dev
   * Test subtract(6, 10) fails
   */
  function subtract(Fraction memory x, Fraction memory y) internal pure returns (Fraction memory) {
    require(x.value >= y.value, "substraction underflow detected");
    return Fraction(x.value - y.value);
  }

  /**
   * @notice x*y. If any of the operators is higher than the max multiplier value it
   * might overflow.
   * @dev The maximum value that can be safely used as a multiplication operator
   * (maxFixedMul) is calculated as sqrt(maxUint256()*fixed1()),
   * or 340282366920938463463374607431768211455999999999999
   * Test multiply(0,0) returns 0
   * Test multiply(maxFixedMul,0) returns 0
   * Test multiply(0,maxFixedMul) returns 0
   * Test multiply(fixed1()/mulPrecision(),fixed1()*mulPrecision()) returns fixed1()
   * Test multiply(maxFixedMul,maxFixedMul) is around maxUint256()
   * Test multiply(maxFixedMul+1,maxFixedMul+1) fails
   */
  function multiply(Fraction memory x, Fraction memory y) internal pure returns (Fraction memory) {
    if (x.value == 0 || y.value == 0) return Fraction(0);
    if (y.value == FIXED1_UINT) return x;
    if (x.value == FIXED1_UINT) return y;

    // Separate into integer and fractional parts
    // x = x1 + x2, y = y1 + y2
    uint256 x1 = integer(x).value / FIXED1_UINT;
    uint256 x2 = fractional(x).value;
    uint256 y1 = integer(y).value / FIXED1_UINT;
    uint256 y2 = fractional(y).value;

    // (x1 + x2) * (y1 + y2) = (x1 * y1) + (x1 * y2) + (x2 * y1) + (x2 * y2)
    uint256 x1y1 = x1 * y1;
    if (x1 != 0) require(x1y1 / x1 == y1, "overflow x1y1 detected");

    // x1y1 needs to be multiplied back by fixed1
    // solium-disable-next-line mixedcase
    uint256 fixed_x1y1 = x1y1 * FIXED1_UINT;
    if (x1y1 != 0) require(fixed_x1y1 / x1y1 == FIXED1_UINT, "overflow x1y1 * fixed1 detected");
    x1y1 = fixed_x1y1;

    uint256 x2y1 = x2 * y1;
    if (x2 != 0) require(x2y1 / x2 == y1, "overflow x2y1 detected");

    uint256 x1y2 = x1 * y2;
    if (x1 != 0) require(x1y2 / x1 == y2, "overflow x1y2 detected");

    x2 = x2 / mulPrecision();
    y2 = y2 / mulPrecision();
    uint256 x2y2 = x2 * y2;
    if (x2 != 0) require(x2y2 / x2 == y2, "overflow x2y2 detected");

    // result = fixed1() * x1 * y1 + x1 * y2 + x2 * y1 + x2 * y2 / fixed1();
    Fraction memory result = Fraction(x1y1);
    result = add(result, Fraction(x2y1)); // Add checks for overflow
    result = add(result, Fraction(x1y2)); // Add checks for overflow
    result = add(result, Fraction(x2y2)); // Add checks for overflow
    return result;
  }

  /**
   * @notice 1/x
   * @dev
   * Test reciprocal(0) fails
   * Test reciprocal(fixed1()) returns fixed1()
   * Test reciprocal(fixed1()*fixed1()) returns 1 // Testing how the fractional is truncated
   * Test reciprocal(1+fixed1()*fixed1()) returns 0 // Testing how the fractional is truncated
   * Test reciprocal(newFixedFraction(1, 1e24)) returns newFixed(1e24)
   */
  function reciprocal(Fraction memory x) internal pure returns (Fraction memory) {
    require(x.value != 0, "can't call reciprocal(0)");
    return Fraction((FIXED1_UINT * FIXED1_UINT) / x.value); // Can't overflow
  }

  /**
   * @notice x/y. If the dividend is higher than the max dividend value, it
   * might overflow. You can use multiply(x,reciprocal(y)) instead.
   * @dev The maximum value that can be safely used as a dividend (maxNewFixed) is defined as
   * divide(maxNewFixed,newFixedFraction(1,fixed1())) is around maxUint256().
   * This yields the value 115792089237316195423570985008687907853269984665640564.
   * Test maxNewFixed equals maxUint256()/fixed1()
   * Test divide(maxNewFixed,1) equals maxNewFixed*(fixed1)
   * Test divide(maxNewFixed+1,multiply(mulPrecision(),mulPrecision())) throws
   * Test divide(fixed1(),0) fails
   * Test divide(maxNewFixed,1) = maxNewFixed*(10^digits())
   * Test divide(maxNewFixed+1,1) throws
   */
  function divide(Fraction memory x, Fraction memory y) internal pure returns (Fraction memory) {
    require(y.value != 0, "can't divide by 0");
    uint256 X = x.value * FIXED1_UINT;
    require(X / FIXED1_UINT == x.value, "overflow at divide");
    return Fraction(X / y.value);
  }

  /**
   * @notice x > y
   */
  function gt(Fraction memory x, Fraction memory y) internal pure returns (bool) {
    return x.value > y.value;
  }

  /**
   * @notice x >= y
   */
  function gte(Fraction memory x, Fraction memory y) internal pure returns (bool) {
    return x.value >= y.value;
  }

  /**
   * @notice x < y
   */
  function lt(Fraction memory x, Fraction memory y) internal pure returns (bool) {
    return x.value < y.value;
  }

  /**
   * @notice x <= y
   */
  function lte(Fraction memory x, Fraction memory y) internal pure returns (bool) {
    return x.value <= y.value;
  }

  /**
   * @notice x == y
   */
  function equals(Fraction memory x, Fraction memory y) internal pure returns (bool) {
    return x.value == y.value;
  }

  /**
   * @notice x <= 1
   */
  function isProperFraction(Fraction memory x) internal pure returns (bool) {
    return lte(x, fixed1());
  }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/common/libraries/Heap.sol

pragma solidity ^0.5.13;


/**
 * @title Simple heap implementation
 */
library Heap {
  using FixidityLib for FixidityLib.Fraction;
  using SafeMath for uint256;

  /**
   * @notice Fixes the heap invariant.
   * @param keys Pointers to values
   * @param values Values that are compared, only the pointers are changed by this method.
   * @param start Node for which the invariant might have changed.
   * @param length Size of the heap.
   */
  function siftDown(
    uint256[] memory keys,
    FixidityLib.Fraction[] memory values,
    uint256 start,
    uint256 length
  ) internal pure {
    require(keys.length == values.length, "key and value array length mismatch");
    require(start < keys.length, "heap start index out of range");
    require(length <= keys.length, "heap length out of range");
    uint256 i = start;
    while (true) {
      uint256 leftChild = i.mul(2).add(1);
      uint256 rightChild = i.mul(2).add(2);
      uint256 maxIndex = i;
      if (leftChild < length && values[keys[leftChild]].gt(values[keys[maxIndex]])) {
        maxIndex = leftChild;
      }
      if (rightChild < length && values[keys[rightChild]].gt(values[keys[maxIndex]])) {
        maxIndex = rightChild;
      }
      if (maxIndex == i) break;
      uint256 tmpKey = keys[i];
      keys[i] = keys[maxIndex];
      keys[maxIndex] = tmpKey;
      i = maxIndex;
    }
  }

  /**
   * @notice Fixes the heap invariant if top has been changed.
   * @param keys Pointers to values
   * @param values Values that are compared, only the pointers are changed by this method.
   */
  function heapifyDown(uint256[] memory keys, FixidityLib.Fraction[] memory values) internal pure {
    siftDown(keys, values, 0, keys.length);
  }

}
