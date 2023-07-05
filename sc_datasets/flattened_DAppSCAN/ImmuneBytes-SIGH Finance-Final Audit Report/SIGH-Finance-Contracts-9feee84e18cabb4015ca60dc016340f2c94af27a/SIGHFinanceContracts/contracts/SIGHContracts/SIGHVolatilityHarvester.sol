// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/CarefulMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
  * @title Careful Math
  * @author Compound
  * @notice Derived from OpenZeppelin's SafeMath library
  *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
  */
contract CarefulMath {

    /**
     * @dev Possible error codes that we can return
     */
    enum MathError {
        NO_ERROR,
        DIVISION_BY_ZERO,
        INTEGER_OVERFLOW,
        INTEGER_UNDERFLOW
    }

    /**
    * @dev Multiplies two numbers, returns an error on overflow.
    */
    function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (a == 0) {
            return (MathError.NO_ERROR, 0);
        }

        uint c = a * b;

        if (c / a != b) {
            return (MathError.INTEGER_OVERFLOW, 0);
        } else {
            return (MathError.NO_ERROR, c);
        }
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (b == 0) {
            return (MathError.DIVISION_BY_ZERO, 0);
        }

        return (MathError.NO_ERROR, a / b);
    }

    /**
    * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
    */
    function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
        if (b <= a) {
            return (MathError.NO_ERROR, a - b);
        } else {
            return (MathError.INTEGER_UNDERFLOW, 0);
        }
    }

    /**
    * @dev Adds two numbers, returns an error on overflow.
    */
    function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
        uint c = a + b;

        if (c >= a) {
            return (MathError.NO_ERROR, c);
        } else {
            return (MathError.INTEGER_OVERFLOW, 0);
        }
    }

    /**
    * @dev add a and b and then subtract c
    */
    function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
        (MathError err0, uint sum) = addUInt(a, b);

        if (err0 != MathError.NO_ERROR) {
            return (err0, 0);
        }

        return subUInt(sum, c);
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/Exponential.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Exponential module for storing fixed-precision decimals
 * @author Compound
 * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
 *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
 *         `Exp({mantissa: 5100000000000000000})`.
 */
contract  Exponential is CarefulMath {
    uint constant expScale = 1e18;
    uint constant doubleScale = 1e36;
    uint constant halfExpScale = expScale/2;
    uint constant mantissaOne = expScale;

    struct Exp {
        uint mantissa;
    }

    struct Double {
        uint mantissa;
    }

    /**
     * @dev Creates an exponential from numerator and denominator values.
     *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
     *            or if `denom` is zero.
     */
    function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: rational}));
    }

    /**
     * @dev Adds two exponentials, returning a new exponential.
     */
    function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
        (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);

        return (error, Exp({mantissa: result}));
    }

    /**
     * @dev Subtracts two exponentials, returning a new exponential.
     */
    function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
        (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);

        return (error, Exp({mantissa: result}));
    }

    /**
     * @dev Multiply an Exp by a scalar, returning a new Exp.
     */
    function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
    }

    /**
     * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
     */
    function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(product));
    }

    /**
     * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
     */
    function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
        (MathError err, Exp memory product) = mulScalar(a, scalar);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return addUInt(truncate(product), addend);
    }

    /**
     * @dev Divide an Exp by a scalar, returning a new Exp.
     */
    function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
        (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
    }

    /**
     * @dev Divide a scalar by an Exp, returning a new Exp.
     */
    function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
        /*
          We are doing this as:
          getExp(mulUInt(expScale, scalar), divisor.mantissa)
          How it works:
          Exp = a / b;
          Scalar = s;
          `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
        */
        (MathError err0, uint numerator) = mulUInt(expScale, scalar);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }
        return getExp(numerator, divisor.mantissa);
    }

    /**
     * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
     */
    function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
        (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
        if (err != MathError.NO_ERROR) {
            return (err, 0);
        }

        return (MathError.NO_ERROR, truncate(fraction));
    }

    /**
     * @dev Multiplies two exponentials, returning a new exponential.
     */
    function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {

        (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
        if (err0 != MathError.NO_ERROR) {
            return (err0, Exp({mantissa: 0}));
        }

        // We add half the scale before dividing so that we get rounding instead of truncation.
        //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
        // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
        (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
        if (err1 != MathError.NO_ERROR) {
            return (err1, Exp({mantissa: 0}));
        }

        (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
        // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
        assert(err2 == MathError.NO_ERROR);

        return (MathError.NO_ERROR, Exp({mantissa: product}));
    }

    /**
     * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
     */
    function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
        return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
    }

    /**
     * @dev Multiplies three exponentials, returning a new exponential.
     */
    function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
        (MathError err, Exp memory ab) = mulExp(a, b);
        if (err != MathError.NO_ERROR) {
            return (err, ab);
        }
        return mulExp(ab, c);
    }

    /**
     * @dev Divides two exponentials, returning a new exponential.
     *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
     *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
     */
    function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
        return getExp(a.mantissa, b.mantissa);
    }

    /**
     * @dev Truncates the given exp to a whole number value.
     *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
     */
    function truncate(Exp memory exp) pure internal returns (uint) {
        // Note: We are not using careful math here as we're performing a division that cannot fail
        return exp.mantissa / expScale;
    }

    /**
     * @dev Checks if first Exp is less than second Exp.
     */
    function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
        return left.mantissa < right.mantissa;
    }

    /**
     * @dev Checks if left Exp <= right Exp.
     */
    function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
        return left.mantissa <= right.mantissa;
    }

    /**
     * @dev Checks if left Exp > right Exp.
     */
    function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
        return left.mantissa > right.mantissa;
    }

    /**
     * @dev returns true if Exp is exactly zero
     */
    function isZeroExp(Exp memory value) pure internal returns (bool) {
        return value.mantissa == 0;
    }

    // function safe256(uint n, string memory errorMessage) pure internal returns (uint256) {
    //     require(n < 2**256, errorMessage);
    //     return uint256(n);
    // }

    function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
        require(n < 2**224, errorMessage);
        return uint224(n);
    }

    function safe224(uint[24] memory n, string memory errorMessage) pure internal returns (uint224[24] memory) {
        uint224[24] memory to_return;
        for (uint i=0; i<24; i++) {
            require(n[i] < 2**224, errorMessage);
            to_return[i] = uint224(n[i]);
        }
        return to_return;
    }

    function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: add_(a.mantissa, b.mantissa)});
    }

    function add_(uint a, uint b) pure internal returns (uint) {
        return add_(a, b, "addition overflow");
    }

    function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        uint c = a + b;
        require(c >= a, errorMessage);
        return c;
    }

    function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: sub_(a.mantissa, b.mantissa)});
    }

    function sub_(uint a, uint b) pure internal returns (uint) {
        return sub_(a, b, "subtraction underflow");
    }

    function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
    }

    function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
        return Exp({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Exp memory b) pure internal returns (uint) {
        return mul_(a, b.mantissa) / expScale;
    }

    function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
    }

    function mul_(Double memory a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: mul_(a.mantissa, b)});
    }

    function mul_(uint a, Double memory b) pure internal returns (uint) {
        return mul_(a, b.mantissa) / doubleScale;
    }

    function mul_(uint a, uint b) pure internal returns (uint) {
        return mul_(a, b, "multiplication overflow");
    }

    function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        if (a == 0 || b == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, errorMessage);
        return c;
    }

    function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
        return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
    }

    function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
        return Exp({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Exp memory b) pure internal returns (uint) {
        return div_(mul_(a, expScale), b.mantissa);
    }

    function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
        return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
    }

    function div_(Double memory a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: div_(a.mantissa, b)});
    }

    function div_(uint a, Double memory b) pure internal returns (uint) {
        return div_(mul_(a, doubleScale), b.mantissa);
    }

    function div_(uint a, uint b) pure internal returns (uint) {
        return div_(a, b, "divide by zero");
    }

    function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function fraction(uint a, uint b) pure internal returns (Double memory) {
        return Double({mantissa: div_(mul_(a, doubleScale), b)});
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/VersionedInitializable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title VersionedInitializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 *
 * @author Aave, SIGH Finance, inspired by the OpenZeppelin Initializable contract
 */
abstract contract VersionedInitializable {
    /**
   * @dev Indicates that the contract has been initialized.
   */
    uint256 private lastInitializedRevision = 0;

    /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
    bool private initializing;

    /**
   * @dev Modifier to use in the initializer function of a contract.
   */
    modifier initializer() {
        uint256 revision = getRevision();
        require(initializing || isConstructor() || revision > lastInitializedRevision, "Contract instance has already been initialized");

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            lastInitializedRevision = revision;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev returns the revision number of the contract.
    /// Needs to be defined in the inherited class as a constant.
    function getRevision() internal virtual pure returns(uint256);


    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        //solium-disable-next-line
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/GlobalAddressesProvider/AddressStorage.sol

// SPDX-License-Identifier: agpl-3.0

pragma solidity 0.7.0;

contract AddressStorage {
    mapping(bytes32 => address) private addresses;

    function getAddress(bytes32 _key) public view returns (address) {
        return addresses[_key];
    }

    function _setAddress(bytes32 _key, address _value) internal {
        addresses[_key] = _value;
    }

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/Proxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title Proxy
 * @dev Implements delegation of calls to other contracts, with proper
 * forwarding of return values and bubbling of failures.
 * It defines a fallback function that delegates all calls to the address
 * returned by the abstract _implementation() internal function.
 */
abstract contract Proxy {
  /**
   * @dev Fallback function.
   * Implemented entirely in `_fallback`.
   */
  fallback() external payable {
    _fallback();
  }

  /**
   * @return The Address of the implementation.
   */
  function _implementation() internal virtual view returns (address);

  /**
   * @dev Delegates execution to an implementation contract.
   * This is a low level function that doesn't return to its internal call site.
   * It will return to the external caller whatever the implementation returns.
   * @param implementation Address to delegate.
   */
  function _delegate(address implementation) internal {
    //solium-disable-next-line
    assembly {
      // Copy msg.data. We take full control of memory in this inline assembly
      // block because it will not return to Solidity code. We overwrite the
      // Solidity scratch pad at memory position 0.
      calldatacopy(0, 0, calldatasize())

      // Call the implementation.
      // out and outsize are 0 because we don't know the size yet.
      let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

      // Copy the returned data.
      returndatacopy(0, 0, returndatasize())

      switch result
        // delegatecall returns 0 on error.
        case 0 {
          revert(0, returndatasize())
        }
        default {
          return(0, returndatasize())
        }
    }
  }

  /**
   * @dev Function that is run as the first thing in the fallback function.
   * Can be redefined in derived contracts to add functionality.
   * Redefinitions must call super._willFallback().
   */
  function _willFallback() internal virtual {}

  /**
   * @dev fallback implementation.
   * Extracted to enable manual triggering.
   */
  function _fallback() internal {
    _willFallback();
    _delegate(_implementation());
  }
  
   /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
     * is empty.
     */
    receive () external payable {
        _fallback();
    }  
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/BaseUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/**
 * @title BaseUpgradeabilityProxy
 * @dev This contract implements a proxy that allows to change the
 * implementation address to which it will delegate.
 * Such a change is called an implementation upgrade.
 */
contract BaseUpgradeabilityProxy is Proxy {
    /**
   * @dev Emitted when the implementation is upgraded.
   * @param implementation Address of the new implementation.
   */
    event Upgraded(address indexed implementation);

    /**
   * @dev Storage slot with the address of the current implementation.
   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is validated in the constructor.
   */
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
   * @dev Returns the current implementation.
   * @return impl Address of the current implementation
   */
    function _implementation() internal view override returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        //solium-disable-next-line
        assembly {
            impl := sload(slot)
        }
    }

    /**
   * @dev Upgrades the proxy to a new implementation.
   * @param newImplementation Address of the new implementation.
   */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
   * @dev Sets the implementation address of the proxy.
   * @param newImplementation Address of the new implementation.
   */
    function _setImplementation(address newImplementation) internal {
        require( Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
        bytes32 slot = IMPLEMENTATION_SLOT;

        //solium-disable-next-line
        assembly {
            sstore(slot, newImplementation)
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/UpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title UpgradeabilityProxy
 * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
 * implementation and init data.
 */
contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
    /**
   * @dev Contract constructor.
   * @param _logic Address of the initial implementation.
   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
   */
    constructor(address _logic, bytes memory _data) payable {
        assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        _setImplementation(_logic);
        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/BaseAdminUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.7.0;

/**
 * @title BaseAdminUpgradeabilityProxy
 * @dev This contract combines an upgradeability proxy with an authorization
 * mechanism for administrative tasks.
 * All external functions in this contract must be guarded by the
 * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
 * feature proposal that would enable this to be done automatically.
 */
contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
  /**
   * @dev Emitted when the administration has been transferred.
   * @param previousAdmin Address of the previous admin.
   * @param newAdmin Address of the new admin.
   */
  event AdminChanged(address previousAdmin, address newAdmin);

  /**
   * @dev Storage slot with the admin of the contract.
   * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
   * validated in the constructor.
   */
  bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

  /**
   * @dev Modifier to check whether the `msg.sender` is the admin.
   * If it is, it will run the function. Otherwise, it will delegate the call
   * to the implementation.
   */
  modifier ifAdmin() {
    if (msg.sender == _admin()) {
      _;
    } else {
      _fallback();
    }
  }

  /**
   * @return The address of the proxy admin.
   */
  function admin() external ifAdmin returns (address) {
    return _admin();
  }

  /**
   * @return The address of the implementation.
   */
  function implementation() external ifAdmin returns (address) {
    return _implementation();
  }

  /**
   * @dev Changes the admin of the proxy.
   * Only the current admin can call this function.
   * @param newAdmin Address to transfer proxy administration to.
   */
  function changeAdmin(address newAdmin) external ifAdmin {
    require(newAdmin != address(0), 'Cannot change the admin of a proxy to the zero address');
    emit AdminChanged(_admin(), newAdmin);
    _setAdmin(newAdmin);
  }

  /**
   * @dev Upgrade the backing implementation of the proxy.
   * Only the admin can call this function.
   * @param newImplementation Address of the new implementation.
   */
  function upgradeTo(address newImplementation) external ifAdmin {
    _upgradeTo(newImplementation);
  }

  /**
   * @dev Upgrade the backing implementation of the proxy and call a function
   * on the new implementation.
   * This is useful to initialize the proxied contract.
   * @param newImplementation Address of the new implementation.
   * @param data Data to send as msg.data in the low level call.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   */
  function upgradeToAndCall(address newImplementation, bytes calldata data)
    external
    payable
    ifAdmin
  {
    _upgradeTo(newImplementation);
    (bool success, ) = newImplementation.delegatecall(data);
    require(success);
  }

  /**
   * @return adm The admin slot.
   */
  function _admin() internal view returns (address adm) {
    bytes32 slot = ADMIN_SLOT;
    //solium-disable-next-line
    assembly {
      adm := sload(slot)
    }
  }

  /**
   * @dev Sets the address of the proxy admin.
   * @param newAdmin Address of the new proxy admin.
   */
  function _setAdmin(address newAdmin) internal {
    bytes32 slot = ADMIN_SLOT;
    //solium-disable-next-line
    assembly {
      sstore(slot, newAdmin)
    }
  }

  /**
   * @dev Only fall back when the sender is not the admin.
   */
  function _willFallback() internal virtual override {
    require(msg.sender != _admin(), 'Cannot call fallback function from the proxy admin');
    super._willFallback();
  }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/InitializableUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title InitializableUpgradeabilityProxy
 * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing implementation and init data.
 */
contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
    
    /**
   * @dev Contract initializer.
   * @param _logic Address of the initial implementation.
   * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
   */
    function initialize(address _logic, bytes memory _data) public payable {
        require(_implementation() == address(0));
        assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
        _setImplementation(_logic);
        if (_data.length > 0) {
            (bool success, ) = _logic.delegatecall(_data);
            require(success);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/InitializableAdminUpgradeabilityProxy.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;


/**
 * @title InitializableAdminUpgradeabilityProxy
 * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for
 * initializing the implementation, admin, and init data.
 */
contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
  /**
   * Contract initializer.
   * @param logic address of the initial implementation.
   * @param admin Address of the proxy administrator.
   * @param data Data to send as msg.data to the implementation to initialize the proxied contract.
   * It should include the signature and the parameters of the function to be called, as described in
   * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
   * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
   */
  function initialize(
    address logic,
    address admin,
    bytes memory data
  ) public payable {
    require(_implementation() == address(0));
    InitializableUpgradeabilityProxy.initialize(logic, data);
    assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
    _setAdmin(admin);
  }

  /**
   * @dev Only fall back when the sender is not the admin.
   */
  function _willFallback() internal override(BaseAdminUpgradeabilityProxy, Proxy) {
    BaseAdminUpgradeabilityProxy._willFallback();
  }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/GlobalAddressesProvider/IGlobalAddressesProvider.sol

// SPDX-License-Identifier: agpl-3.0

pragma solidity ^0.7.0;

/**
@title GlobalAddressesProvider interface
@notice provides the interface to fetch the LendingPoolCore address
 */

interface IGlobalAddressesProvider  {

// ########################################################################################
// #########  PROTOCOL MANAGERS ( LendingPool Manager and SighFinance Manager ) ###########
// ########################################################################################

    function getLendingPoolManager() external view returns (address);
    function getPendingLendingPoolManager() external view returns (address);

    function setPendingLendingPoolManager(address _pendinglendingPoolManager) external;
    function acceptLendingPoolManager() external;

    function getSIGHFinanceManager() external view returns (address);
    function getPendingSIGHFinanceManager() external view returns (address);

    function setPendingSIGHFinanceManager(address _PendingSIGHFinanceManager) external;
    function acceptSIGHFinanceManager() external;

// #########################################################################
// ####___________ LENDING POOL PROTOCOL CONTRACTS _____________############
// ########## 1. LendingPoolConfigurator (Upgradagble) #####################
// ########## 2. LendingPoolCore (Upgradagble) #############################
// ########## 3. LendingPool (Upgradagble) #################################
// ########## 4. LendingPoolDataProvider (Upgradagble) #####################
// ########## 5. LendingPoolParametersProvider (Upgradagble) ###############
// ########## 6. FeeProvider (Upgradagble) #################################
// ########## 7. LendingPoolLiqAndLoanManager (Directly Changed) ##########
// ########## 8. LendingRateOracle (Directly Changed) ######################
// #########################################################################

    function getLendingPoolConfigurator() external view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) external;

    function getLendingPool() external view returns (address);
    function setLendingPoolImpl(address _pool) external;

    function getFeeProvider() external view returns (address);
    function setFeeProviderImpl(address _feeProvider) external;

    function getLendingPoolLiqAndLoanManager() external view returns (address);
    function setLendingPoolLiqAndLoanManager(address _manager) external;

    function getLendingRateOracle() external view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) external;

// ####################################################################################
// ####___________ SIGH FINANCE RELATED CONTRACTS _____________########################
// ########## 1. SIGH (Initialized only once) #########################################
// ########## 2. SIGH Finance Configurator (Upgradagble) ################################
// ########## 2. SIGH Speed Controller (Initialized only once) ########################
// ########## 3. SIGH Treasury (Upgradagble) ###########################################
// ########## 4. SIGH Mechanism Handler (Upgradagble) ###################################
// ########## 5. SIGH Staking (Upgradagble) ###################################
// ####################################################################################

    function getSIGHAddress() external view returns (address);
    function setSIGHAddress(address sighAddress) external;

    function getSIGHNFTBoosters() external view returns (address) ;
    function setSIGHNFTBoosters(address _SIGHNFTBooster) external ;

    function getSIGHFinanceConfigurator() external view returns (address);
    function setSIGHFinanceConfiguratorImpl(address sighAddress) external;

    function getSIGHSpeedController() external view returns (address);
    function setSIGHSpeedController(address _SIGHSpeedController) external;

    function getSIGHTreasury() external view returns (address);                                 //  ADDED FOR SIGH FINANCE
    function setSIGHTreasuryImpl(address _SIGHTreasury) external;                                   //  ADDED FOR SIGH FINANCE

    function getSIGHVolatilityHarvester() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHVolatilityHarvesterImpl(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

    function getSIGHStaking() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHStaking(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

// #######################################################
// ####___________ PRICE ORACLE CONTRACT _____________####
// ####_____ SIGH FINANCE FEE COLLECTOR : ADDRESS ____####
// ####_____   SIGH PAYCOLLECTOR : ADDRESS        ____####
// #######################################################

    function getPriceOracle() external view returns (address);
    function setPriceOracle(address _priceOracle) external;


    // SIGH FINANCE FEE COLLECTOR - DEPOSIT / BORROWING / FLASH LOAN FEE TRANSERRED TO THIS ADDRESS
    function getSIGHFinanceFeeCollector() external view returns (address) ;
    function setSIGHFinanceFeeCollector(address _feeCollector) external ;

    function getSIGHPAYAggregator() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHPAYAggregator(address _SIGHPAYAggregator) external;             //  ADDED FOR SIGH FINANCE

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/GlobalAddressesProvider/GlobalAddressesProvider.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;


/**
* @title GlobalAddressesProvider contract
* @notice Is the main registry of the protocol. All the different components of the protocol are accessible through the addresses provider.
* @author _astromartian, built upon the Aave protocol's AddressesProviderContract(v1)
**/

contract GlobalAddressesProvider is IGlobalAddressesProvider, AddressStorage {

    bool isSighInitialized;
    bool isNFTBoosterInitialized;

    //#############################################
    //################### EVENTS ##################
    //#############################################
    
    //LendingPool and SIGH Finance Managers
    event PendingSIGHFinanceManagerUpdated( address _pendingSighFinanceManager );
    event SIGHFinanceManagerUpdated( address _sighFinanceManager );
    event PendingLendingPoolManagerUpdated( address _pendingLendingPoolManager );
    event LendingPoolManagerUpdated( address _lendingPoolManager );

    //LendingPool Contracts
    event LendingPoolConfiguratorUpdated(address indexed newAddress);
    event LendingPoolUpdated(address indexed newAddress);
    event LendingPoolLiqAndLoanManagerUpdated(address indexed newAddress);
    event LendingRateOracleUpdated(address indexed newAddress);
    event FeeProviderUpdated(address indexed newAddress);

    //SIGH Finance Contracts
    event SIGHFinanceConfiguratorUpdated(address indexed sighFinanceConfigAddress);       
    event SIGHAddressUpdated(address indexed sighAddress);    
    event SIGHNFTBoosterUpdated(address indexed boosterAddress);
    event SIGHSpeedControllerUpdated(address indexed speedControllerAddress);
    event SIGHVolatilityHarvesterImplUpdated(address indexed newAddress);                   
    event SIGHTreasuryImplUpdated(address indexed newAddress);                           
    event SIGHStakingImplUpdated(address indexed SIGHStakingAddress);                    

    //Contracts which collect Fee & SIGH Pay
    event SIGHFinanceFeeCollectorUpdated(address indexed newAddress);
    event SIGHFinanceSIGHPAYAggregatorUpdated(address indexed newAddress);

    //Price Oracle and general events
    event PriceOracleUpdated(address indexed newAddress);
    event ProxyCreated(bytes32 id, address indexed newAddress);

    //#########################################################
    //################### bytes32 parameters ##################
    //#########################################################
    
    //LendingPool and SIGH Finance Managers    
    bytes32 private constant LENDING_POOL_MANAGER = "LENDING_POOL_MANAGER";                         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE LENDINGPOOL
    bytes32 private constant PENDING_LENDING_POOL_MANAGER = "PENDING_LENDING_POOL_MANAGER";         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE LENDINGPOOL 
    bytes32 private constant SIGH_FINANCE_MANAGER = "SIGH_FINANCE_MANAGER";                         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE SIGH FINANCE
    bytes32 private constant PENDING_SIGH_FINANCE_MANAGER = "PENDING_SIGH_FINANCE_MANAGER";         // MULTISIG ACCOUNT WHICH CONTROLS THE UPDATES TO THE SIGH FINANCE 

    //LendingPool Contracts    
    bytes32 private constant LENDING_POOL_CONFIGURATOR = "LENDING_POOL_CONFIGURATOR";       // CONTROLLED BY LENDINGPOOL MANAGER. MAKES STATE CHANGES RELATED TO LENDING PROTOCOL
    bytes32 private constant LENDING_POOL = "LENDING_POOL";
    bytes32 private constant LENDING_POOL_LIQANDLOAN_MANAGER = "LIQANDLOAN_MANAGER";
    bytes32 private constant LENDING_RATE_ORACLE = "LENDING_RATE_ORACLE";
    bytes32 private constant FEE_PROVIDER = "FEE_PROVIDER";

    //SIGH Finance Contracts
    bytes32 private constant SIGH_FINANCE_CONFIGURATOR = "SIGH_FINANCE_CONFIGURATOR";       // CONTROLLED BY SIGHFINANCE MANAGER. MAKES STATE CHANGES RELATED TO SIGH FINANCE
    bytes32 private constant SIGH = "SIGH";
    bytes32 private constant SIGH_Finance_NFT_BOOSTERS = "SIGH_Finance_NFT_BOOSTERS";
    bytes32 private constant SIGH_SPEED_CONTROLLER = "SIGH_SPEED_CONTROLLER";           
    bytes32 private constant SIGH_VOLATILITY_HARVESTER = "SIGH_VOLATILITY_HARVESTER";         
    bytes32 private constant SIGH_TREASURY = "SIGH_TREASURY";                           
    bytes32 private constant SIGH_STAKING = "SIGH_STAKING";                             

    //Contracts which collect Fee & SIGH Pay
    bytes32 private constant SIGH_Finance_Fee_Collector = "SIGH_Finance_Fee_Collector";
    bytes32 private constant SIGH_Finance_SIGHPAY_AGGREGATOR = "SIGH_Finance_SIGHPAY_AGGREGATOR";

    //Price Oracle and general contracts
    bytes32 private constant PRICE_ORACLE = "PRICE_ORACLE";


// ################################
// ######  CONSTRUCTOR ############
// ################################

    constructor(address SIGHFinanceManagerAddress, address LendingPoolManagerAddress) {
        _setAddress(SIGH_FINANCE_MANAGER, SIGHFinanceManagerAddress);
        _setAddress(LENDING_POOL_MANAGER, LendingPoolManagerAddress);

        emit SIGHFinanceManagerUpdated( getAddress(SIGH_FINANCE_MANAGER) );
        emit LendingPoolManagerUpdated( getAddress(LENDING_POOL_MANAGER) );
    }

// ################################
// #########  MODIFIERS ###########
// ################################

    modifier onlySIGHFinanceManager {
        address sighFinanceManager =  getAddress(SIGH_FINANCE_MANAGER);
        require( sighFinanceManager == msg.sender, "The caller must be the SIGH FINANCE Manager" );
        _;
    }

    modifier onlyLendingPoolManager {
        address LendingPoolManager =  getAddress(LENDING_POOL_MANAGER);
        require( LendingPoolManager == msg.sender, "The caller must be the Lending Protocol Manager" );
        _;
    }

// ########################################################################################
// #########  PROTOCOL MANAGERS ( LendingPool Manager and SighFinance Manager ) ###########
// ########################################################################################

    function getLendingPoolManager() external view override returns (address) {
        return getAddress(LENDING_POOL_MANAGER);
    }

    function getPendingLendingPoolManager() external view override returns (address) {
        return getAddress(PENDING_LENDING_POOL_MANAGER);
    }

    function setPendingLendingPoolManager(address _pendinglendingPoolManager) external override  onlyLendingPoolManager {
        _setAddress(PENDING_LENDING_POOL_MANAGER, _pendinglendingPoolManager);
        emit PendingLendingPoolManagerUpdated(_pendinglendingPoolManager);
    }

    function acceptLendingPoolManager() external override {
        address pendingLendingPoolManager = getAddress(PENDING_LENDING_POOL_MANAGER);
        require(msg.sender == pendingLendingPoolManager, "Only the Pending Lending Pool Manager can call this function to be accepted to become the Lending Pool Manager");
        _setAddress(LENDING_POOL_MANAGER, pendingLendingPoolManager);
        _setAddress(PENDING_LENDING_POOL_MANAGER, address(0));
        emit PendingLendingPoolManagerUpdated( getAddress(PENDING_LENDING_POOL_MANAGER) );
        emit LendingPoolManagerUpdated( getAddress(LENDING_POOL_MANAGER) );
    }

    function getSIGHFinanceManager() external view override returns (address) {
        return getAddress(SIGH_FINANCE_MANAGER);
    }

    function getPendingSIGHFinanceManager() external view override returns (address) {
        return getAddress(PENDING_SIGH_FINANCE_MANAGER);
    }

    function setPendingSIGHFinanceManager(address _PendingSIGHFinanceManager) external override  onlySIGHFinanceManager {
        _setAddress(PENDING_SIGH_FINANCE_MANAGER, _PendingSIGHFinanceManager);
        emit PendingSIGHFinanceManagerUpdated(_PendingSIGHFinanceManager);
    }

    function acceptSIGHFinanceManager() external override {
        address _PendingSIGHFinanceManager = getAddress(PENDING_SIGH_FINANCE_MANAGER);
        require(msg.sender == _PendingSIGHFinanceManager, "Only the Pending SIGH Finance Manager can call this function to be accepted to become the SIGH Finance Manager");
        _setAddress(SIGH_FINANCE_MANAGER, _PendingSIGHFinanceManager);
        _setAddress(PENDING_SIGH_FINANCE_MANAGER, address(0));
        emit PendingSIGHFinanceManagerUpdated( getAddress(PENDING_SIGH_FINANCE_MANAGER) );
        emit SIGHFinanceManagerUpdated( getAddress(SIGH_FINANCE_MANAGER) );
    }


// #########################################################################
// ####___________ LENDING POOL PROTOCOL CONTRACTS _____________############
// ########## 1. LendingPoolConfigurator (Upgradagble) #####################
// ########## 3. LendingPool (Upgradagble) #################################
// ########## 6. FeeProvider (Upgradagble) #################################
// ########## 7. LendingPoolLiqAndLoanManager (Directly Changed) ##########
// ########## 8. LendingRateOracle (Directly Changed) ######################
// #########################################################################


// ############################################
// ######  LendingPoolConfigurator proxy ######
// ############################################

    /**
    * @dev returns the address of the LendingPoolConfigurator proxy
    * @return the lending pool configurator proxy address
    **/
    function getLendingPoolConfigurator() external view override returns (address) {
        return getAddress(LENDING_POOL_CONFIGURATOR);
    }

    /**
    * @dev updates the implementation of the lending pool configurator
    * @param _configurator the new lending pool configurator implementation
    **/
    function setLendingPoolConfiguratorImpl(address _configurator) external override onlyLendingPoolManager {
        updateImplInternal(LENDING_POOL_CONFIGURATOR, _configurator);
        emit LendingPoolConfiguratorUpdated(_configurator);
    }



// ################################
// ######  LendingPool proxy ######
// ################################
    /**
    * @dev returns the address of the LendingPool proxy
    * @return the lending pool proxy address
    **/
    function getLendingPool() external view override returns (address) {
        return getAddress(LENDING_POOL);
    }


    /**
    * @dev updates the implementation of the lending pool
    * @param _pool the new lending pool implementation
    **/
    function setLendingPoolImpl(address _pool) external override onlyLendingPoolManager {
        updateImplInternal(LENDING_POOL, _pool);
        emit LendingPoolUpdated(_pool);
    }
    
    
// ###################################
// ######  getFeeProvider proxy ######
// ###################################
    /**
    * @dev returns the address of the FeeProvider proxy
    * @return the address of the Fee provider proxy
    **/
    function getFeeProvider() external view override returns (address) {
        return getAddress(FEE_PROVIDER);
    }

    /**
    * @dev updates the implementation of the FeeProvider proxy
    * @param _feeProvider the new lending pool fee provider implementation
    **/
    function setFeeProviderImpl(address _feeProvider) external override onlyLendingPoolManager {
        updateImplInternal(FEE_PROVIDER, _feeProvider);
        emit FeeProviderUpdated(_feeProvider);
    }

// ##################################################
// ######  LendingPoolLiqAndLoanManager ######
// ##################################################
    /**
    * @dev returns the address of the LendingPoolLiqAndLoanManager. Since the manager is used
    * through delegateCall within the LendingPool contract, the proxy contract pattern does not work properly hence
    * the addresses are changed directly.
    * @return the address of the Lending pool LiqAndLoan manager
    **/

    function getLendingPoolLiqAndLoanManager() external view override returns (address) {
        return getAddress(LENDING_POOL_LIQANDLOAN_MANAGER);
    }

    /**
    * @dev updates the address of the Lending pool LiqAndLoan manager
    * @param _manager the new lending pool LiqAndLoan manager address
    **/
    function setLendingPoolLiqAndLoanManager(address _manager) external override onlyLendingPoolManager {
        _setAddress(LENDING_POOL_LIQANDLOAN_MANAGER, _manager);
        emit LendingPoolLiqAndLoanManagerUpdated(_manager);
    }

// ##################################################
// ######  LendingRateOracle ##################
// ##################################################

    function getLendingRateOracle() external view override returns (address) {
        return getAddress(LENDING_RATE_ORACLE);
    }

    function setLendingRateOracle(address _lendingRateOracle) external override onlyLendingPoolManager {
        _setAddress(LENDING_RATE_ORACLE, _lendingRateOracle);
        emit LendingRateOracleUpdated(_lendingRateOracle);
    }


// ####################################################################################
// ####___________ SIGH FINANCE RELATED CONTRACTS _____________########################
// ########## 1. SIGH (Initialized only once) #########################################
// ########## 1. SIGH NFT BOOSTERS (Initialized only once) ############################
// ########## 2. SIGHFinanceConfigurator (Upgradable) #################################
// ########## 2. SIGH Speed Controller (Initialized only once) ########################
// ########## 3. SIGHTreasury (Upgradagble) ###########################################
// ########## 4. SIGHVolatilityHarvester (Upgradagble) ###################################
// ########## 5. SIGHStaking (Upgradagble) ###################################
// ####################################################################################

// ################################                                                     
// ######  SIGH ADDRESS ###########                                                     
// ################################                                                     

    function getSIGHAddress() external view override returns (address) {
        return getAddress(SIGH);
    }

    function setSIGHAddress(address sighAddress) external override onlySIGHFinanceManager {
        // require (!isSighInitialized, "SIGH Instrument address can only be initialized once.");
        isSighInitialized  = true;
        // updateImplInternal(SIGH, sighAddress);
        _setAddress(SIGH, sighAddress);
        emit SIGHAddressUpdated(sighAddress);
    }

// #####################################
// ######  SIGH NFT BOOSTERS ###########
// #####################################

    // SIGH FINANCE NFT BOOSTERS - Provide Discount on Deposit & Borrow Fee
    function getSIGHNFTBoosters() external view override returns (address) {
        return getAddress(SIGH_Finance_NFT_BOOSTERS);
    }

    function setSIGHNFTBoosters(address _SIGHNFTBooster) external override onlySIGHFinanceManager {
        // require (!isNFTBoosterInitialized, "SIGH NFT Boosters address can only be initialized once.");
//        isNFTBoosterInitialized  = true;
        _setAddress(SIGH_Finance_NFT_BOOSTERS, _SIGHNFTBooster);
        emit SIGHNFTBoosterUpdated(_SIGHNFTBooster);
    }

// ############################################
// ######  SIGHFinanceConfigurator proxy ######
// ############################################

    /**
    * @dev returns the address of the SIGHFinanceConfigurator proxy
    * @return the SIGH Finance configurator proxy address
    **/
    function getSIGHFinanceConfigurator() external view override returns (address) {
        return getAddress(SIGH_FINANCE_CONFIGURATOR);
    }

    /**
    * @dev updates the implementation of the lending pool configurator
    * @param _configurator the new lending pool configurator implementation
    **/
    function setSIGHFinanceConfiguratorImpl(address _configurator) external override onlySIGHFinanceManager {
        updateImplInternal(SIGH_FINANCE_CONFIGURATOR, _configurator);
        emit SIGHFinanceConfiguratorUpdated(_configurator);
    }

// ############################################
// ######  SIGH Speed Controller ########
// ############################################

    /**
    * @dev returns the address of the SIGH_SPEED_CONTROLLER proxy
    * @return the SIGH Speed Controller address
    **/
    function getSIGHSpeedController() external view override returns (address) {
        return getAddress(SIGH_SPEED_CONTROLLER);
    }

    /**
    * @dev sets the address of the SIGH Speed Controller
    * @param _SIGHSpeedController the SIGH Speed Controller implementation
    **/
    function setSIGHSpeedController(address _SIGHSpeedController) external override onlySIGHFinanceManager {
        // require (!isSighSpeedControllerInitialized, "SIGH Speed Controller address can only be initialized once.");
        // isSighSpeedControllerInitialized  = true;
        updateImplInternal(SIGH_SPEED_CONTROLLER, _SIGHSpeedController);
        emit SIGHSpeedControllerUpdated(_SIGHSpeedController);
    }



// #################################  ADDED BY SIGH FINANCE
// ######  SIGHTreasury proxy ######  ADDED BY SIGH FINANCE
// #################################  ADDED BY SIGH FINANCE

    function getSIGHTreasury() external view override returns (address) {
        return getAddress(SIGH_TREASURY);
    }

    /**
    * @dev updates the address of the SIGH Treasury Contract
    * @param _SIGHTreasury the new SIGH Treasury Contract address
    **/
    function setSIGHTreasuryImpl(address _SIGHTreasury) external override onlySIGHFinanceManager {
        updateImplInternal(SIGH_TREASURY, _SIGHTreasury);
        emit SIGHTreasuryImplUpdated(_SIGHTreasury);
    }

// #############################################  ADDED BY SIGH FINANCE
// ######  SIGHVolatilityHarvester proxy #######     ADDED BY SIGH FINANCE
// #############################################  ADDED BY SIGH FINANCE

    function getSIGHVolatilityHarvester() external view override returns (address) {
        return getAddress(SIGH_VOLATILITY_HARVESTER);
    }

    /**
    * @dev updates the address of the SIGH Distribution Handler Contract (Manages the SIGH Speeds)
    * @param _SIGHVolatilityHarvester the new SIGH Distribution Handler (Impl) Address
    **/
    function setSIGHVolatilityHarvesterImpl(address _SIGHVolatilityHarvester) external override onlySIGHFinanceManager  {
        updateImplInternal(SIGH_VOLATILITY_HARVESTER, _SIGHVolatilityHarvester);
        emit SIGHVolatilityHarvesterImplUpdated(_SIGHVolatilityHarvester);
    }

// #############################################  ADDED BY SIGH FINANCE
// ######  SIGHStaking proxy ###################  ADDED BY SIGH FINANCE
// #############################################  ADDED BY SIGH FINANCE

    function getSIGHStaking() external view override returns (address) {
        return getAddress(SIGH_STAKING);
    }

    /**
    * @dev updates the address of the SIGH Distribution Handler Contract (Manages the SIGH Speeds)
    * @param _SIGHStaking the new lending pool LiqAndLoan manager address
    **/
    function setSIGHStaking(address _SIGHStaking) external override onlySIGHFinanceManager  {
        updateImplInternal(SIGH_STAKING, _SIGHStaking);
        emit SIGHStakingImplUpdated(_SIGHStaking);
    }

// #############################################
// ######  SIGH PAY AGGREGATOR #################
// #############################################

    // SIGH FINANCE : SIGH PAY AGGREGATOR - Collects SIGH PAY Payments
    function getSIGHPAYAggregator() external view override returns (address) {
        return getAddress(SIGH_Finance_SIGHPAY_AGGREGATOR);
    }

    function setSIGHPAYAggregator(address _SIGHPAYAggregator) external override onlySIGHFinanceManager {
        updateImplInternal(SIGH_Finance_SIGHPAY_AGGREGATOR, _SIGHPAYAggregator);
        emit SIGHFinanceSIGHPAYAggregatorUpdated(_SIGHPAYAggregator);
    }

// ####################################################
// ######  SIGH FINANCE FEE COLLECTOR #################
// ###################################################

    // SIGH FINANCE FEE COLLECTOR - BORROWING / FLASH LOAN FEE TRANSFERRED TO THIS ADDRESS
    function getSIGHFinanceFeeCollector() external view override returns (address) {
        return getAddress(SIGH_Finance_Fee_Collector);
    }

    function setSIGHFinanceFeeCollector(address _feeCollector) external override onlySIGHFinanceManager {
        _setAddress(SIGH_Finance_Fee_Collector, _feeCollector);
        emit SIGHFinanceFeeCollectorUpdated(_feeCollector);
    }

// ###################################################################################
// ######  THESE CONTRACTS ARE NOT USING PROXY SO ADDRESS ARE DIRECTLY UPDATED #######
// ###################################################################################

    /**
    * @dev the functions below are storing specific addresses that are outside the context of the protocol
    * hence the upgradable proxy pattern is not used
    **/
    function getPriceOracle() external view override returns (address) {
        return getAddress(PRICE_ORACLE);
    }

    function setPriceOracle(address _priceOracle) external override onlyLendingPoolManager {
        _setAddress(PRICE_ORACLE, _priceOracle);
        emit PriceOracleUpdated(_priceOracle);
    }


// #############################################
// ######  FUNCTION TO UPGRADE THE PROXY #######
// #############################################

    /**
    * @dev internal function to update the implementation of a specific component of the protocol
    * @param _id the id of the contract to be updated
    * @param _newAddress the address of the new implementation
    **/
    function updateImplInternal(bytes32 _id, address _newAddress) internal {
        address payable proxyAddress = address(uint160(getAddress(_id)));

        InitializableAdminUpgradeabilityProxy proxy = InitializableAdminUpgradeabilityProxy(proxyAddress);
        bytes memory params = abi.encodeWithSignature("initialize(address)", address(this));            // initialize function is called in the new implementation contract

        if (proxyAddress == address(0)) {
            proxy = new InitializableAdminUpgradeabilityProxy();
            proxy.initialize(_newAddress, address(this), params);
            _setAddress(_id, address(proxy));
            emit ProxyCreated(_id, address(proxy));
        } else {
            proxy.upgradeToAndCall(_newAddress, params);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/GSN/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
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
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
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
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/IPriceOracleGetter.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title IPriceOracleGetter interface
 * @notice Interface for the SIGH Finance price oracle.
 **/

interface IPriceOracleGetter {

  /**
   * @dev returns the asset price in USD
   * @param asset the address of the asset
   * @return the USD price of the asset
   **/
  function getAssetPrice(address asset) external view returns (uint256);

  /**
   * @dev returns the decimals correction of the USD price
   * @param asset the address of the asset
   * @return  the decimals correction of the USD price
   **/
  function getAssetPriceDecimals(address asset) external view returns (uint8);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/types/DataTypes.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

library DataTypes {

  struct InstrumentData {

    InstrumentConfigurationMap configuration;      //stores the instrument configuration
    uint128 liquidityIndex;                     //the liquidity index. Expressed in ray
    uint128 variableBorrowIndex;                //variable borrow index. Expressed in ray

    uint128 currentLiquidityRate;               //the current supply rate. Expressed in ray
    uint128 currentVariableBorrowRate;          //the current variable borrow rate. Expressed in ray
    uint128 currentStableBorrowRate;            //the current stable borrow rate. Expressed in ray

    uint40 lastUpdateTimestamp;

    address iTokenAddress;                      //tokens addresses
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;

    address interestRateStrategyAddress;        //address of the interest rate strategy

    uint8 id;                                   //the id of the instrument. Represents the position in the list of the active instruments
    uint8 decimals;
  }

  struct InstrumentConfigurationMap {
    //bit 0-15: LTV
    //bit 16-31: Liq. threshold
    //bit 32-47: Liq. bonus
    //bit 48-55: Decimals
    //bit 56: Reserve is active
    //bit 57: reserve is frozen
    //bit 58: borrowing is enabled
    //bit 59: stable rate borrowing enabled
    //bit 60-63: reserved
    //bit 64-79: reserve factor
    uint256 data;
  }

  struct UserConfigurationMap {
    uint256 data;
  }

  enum InterestRateMode {NONE, STABLE, VARIABLE}
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ILendingPool.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;


interface ILendingPool {

    //######################################
    //############### EVENTS ###############
    //######################################

  /**
   * @dev Emitted on deposit()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   **/
  event Deposit(address indexed instrument, address indexed user,uint256 amount);

  /**
   * @dev Emitted on withdraw()
   * @param instrument The address of the underlyng asset being withdrawn
   * @param user The address initiating the withdrawal, owner of iTokens
   * @param to Address that will receive the underlying
   * @param amount The amount to be withdrawn
   **/
  event Withdraw(address indexed instrument, address indexed user, address indexed to, uint256 amount);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrument The address of the underlying asset being borrowed
   * @param user The address of the user initiating the borrow(), receiving the funds on borrow() or just
   * initiator of the transaction on flashLoan()
   * @param onBehalfOf The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param borrowRateMode The rate mode: 1 for Stable, 2 for Variable
   * @param borrowRate The numeric rate at which the user has borrowed
   **/
  event Borrow(address indexed instrument, address user, address indexed onBehalfOf, uint256 amount, uint256 borrowRateMode, uint256 borrowRate);

  /**
   * @dev Emitted on repay()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The beneficiary of the repayment, getting his debt reduced
   * @param repayer The address of the user initiating the repay(), providing the funds
   * @param loanRepaid The amount repaid
   * @param totalFeeRepaid The total Fee repaid
   **/
  event Repay(address indexed instrument, address indexed user, address indexed repayer, uint256 loanRepaid, uint256 totalFeeRepaid);

  /**
   * @dev Emitted on swapBorrowRateMode()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address of the user swapping his rate mode
   * @param rateMode The rate mode that the user wants to swap to
   **/
  event Swap(address indexed instrument, address indexed user, uint256 rateMode);

  /**
   * @dev Emitted on setUserUseInstrumentAsCollateral()
   * @param instrument The address of the underlying asset of the instrument
   * @param user The address of the user enabling the usage as collateral
   **/
  event InstrumentUsedAsCollateralEnabled(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on setUserUseInstrumentAsCollateral()
   * @param instrument The address of the underlying asset
   * @param user The address of the user enabling the usage as collateral
   **/
  event InstrumentUsedAsCollateralDisabled(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on rebalanceStableBorrowRate()
   * @param instrument The address of the underlying asset
   * @param user The address of the user for which the rebalance has been executed
   **/
  event RebalanceStableBorrowRate(address indexed instrument, address indexed user);

  /**
   * @dev Emitted on flashLoan()
   * @param target The address of the flash loan receiver contract
   * @param initiator The address initiating the flash loan
   * @param asset The address of the asset being flash borrowed
   * @param amount The amount flash borrowed
   * @param premium The fee flash borrowed
   * @param boosterID  The boosterID of the Booster used to get a discount on the Fee
   **/
  event FlashLoan(address indexed target, address indexed initiator, address indexed asset, uint256 amount, uint256 premium, uint16 boosterID );

  event Paused();
  event Unpaused();

  /**
   * @dev Emitted when a borrower is liquidated. This event is emitted by the LendingPool via
   * LendingPoolCollateral manager using a DELEGATECALL
   * This allows to have the events in the generated ABI for LendingPool.
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param liquidatedCollateralAmount The amount of collateral received by the liiquidator
   * @param liquidator The address of the liquidator
   * @param receiveIToken `true` if the liquidators wants to receive the collateral iTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  event LiquidationCall(address indexed collateralAsset, address indexed debtAsset, address indexed user, uint256 debtToCover, uint256 liquidatedCollateralAmount, address liquidator, bool receiveIToken);

  /**
   * @dev Emitted when the state of a instrument is updated. NOTE: This event is actually declared
   * in the InstrumentLogic library and emitted in the updateInterestRates() function. Since the function is internal,
   * the event will actually be fired by the LendingPool contract. The event is therefore replicated here so it gets added to the LendingPool ABI
   * @param instrument The address of the underlying asset
   * @param liquidityRate The new liquidity rate
   * @param stableBorrowRate The new stable borrow rate
   * @param variableBorrowRate The new variable borrow rate
   * @param liquidityIndex The new liquidity index
   * @param variableBorrowIndex The new variable borrow index
   **/
  event InstrumentDataUpdated(address indexed instrument, uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate, uint256 liquidityIndex, uint256 variableBorrowIndex);

  /**
   * @dev Emitted on deposit()
   * @param instrumentAddress The address of the underlying asset 
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/
  event depositFeeDeducted(address instrumentAddress, address user, uint amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);
  
  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/  
  event borrowFeeUpdated(address instrumentAddress, address user, uint256 amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address repaying the amount
   * @param onBehalfOf The user whose debt is being repaid
   * @param amount The amount borrowed out
   * @param platformFeePay Platform Fee paid
   * @param reserveFeePay Reserve Fee paid
   **/  
  event feeRepaid(address instrumentAddress, address user, address onBehalfOf, uint256 amount, uint256 platformFeePay, uint256 reserveFeePay);



    //#########################################
    //############### FUNCTIONS ###############
    //#########################################



  function refreshConfig() external;

  /**
   * @dev Deposits an `amount` of underlying asset, receiving in return overlying iTokens.
   * - E.g. User deposits 100 USDC and gets in return 100 aUSDC
   * @param asset The address of the underlying asset to deposit
   * @param amount The amount to be deposited
   * @param boosterID of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   **/
  function deposit(address asset, uint256 amount, uint16 boosterID) external;

  /**
   * @dev Withdraws an `amount` of underlying asset, burning the equivalent iTokens owned
   * E.g. User has 100 aUSDC, calls withdraw() and receives 100 USDC, burning the 100 aUSDC
   * @param asset The address of the underlying asset to withdraw
   * @param amount The underlying amount to be withdrawn
   *   - Send the value type(uint256).max in order to withdraw the whole iToken balance
   * @param to Address that will receive the underlying, same as msg.sender if the user
   *   wants to receive it on his own wallet, or a different address if the beneficiary is a
   *   different wallet
   * @return The final amount withdrawn
   **/
  function withdraw(address asset, uint256 amount, address to) external returns (uint256);

  /**
   * @dev Allows users to borrow a specific `amount` of the underlying asset, provided that the borrower
   * already deposited enough collateral, or he was given enough allowance by a credit delegator on the
   * corresponding debt token (StableDebtToken or VariableDebtToken)
   * - E.g. User borrows 100 USDC passing as `onBehalfOf` his own address, receiving the 100 USDC in his wallet
   *   and 100 stable/variable debt tokens, depending on the `interestRateMode`
   * @param asset The address of the underlying asset to borrow
   * @param amount The amount to be borrowed
   * @param interestRateMode The interest rate mode at which the user wants to borrow: 1 for Stable, 2 for Variable
   * @param boosterID of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   * @param onBehalfOf Address of the user who will receive the debt. Should be the address of the borrower itself
   * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
   * if he has been given credit delegation allowance
   **/
  function borrow(address asset, uint256 amount, uint256 interestRateMode, uint16 boosterID, address onBehalfOf) external;

  /**
   * @notice Repays a borrowed `amount`, burning the equivalent debt tokens owned
   * - E.g. User repays 100 USDC, burning 100 variable/stable debt tokens of the `onBehalfOf` address
   * @param asset The address of the borrowed underlying asset previously borrowed
   * @param amount The amount to repay
   * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
   * @param rateMode The interest rate mode at of the debt the user wants to repay: 1 for Stable, 2 for Variable
   * @param onBehalfOf Address of the user who will get his debt reduced/removed. Should be the address of the
   * user calling the function if he wants to reduce/remove his own debt, or the address of any other
   * other borrower whose debt should be removed
   * @return The final amount repaid
   **/
  function repay(address asset, uint256 amount, uint256 rateMode, address onBehalfOf) external returns (uint256);

  /**
   * @dev Allows a borrower to swap his debt between stable and variable mode, or viceversa
   * @param asset The address of the underlying asset borrowed
   * @param rateMode The rate mode that the user wants to swap to
   **/
  function swapBorrowRateMode(address asset, uint256 rateMode) external;

  /**
   * @dev Rebalances the stable interest rate of a user to the current stable rate defined
   * - Users can be rebalanced if the following conditions are satisfied:
   *     1. Usage ratio is above 95%
   *     2. the current deposit APY is below REBALANCE_UP_THRESHOLD * maxVariableBorrowRate, which means that too much has been
   *        borrowed at a stable rate and depositors are not earning enough
   * @param asset The address of the underlying asset borrowed
   * @param user The address of the user to be rebalanced
   **/
  function rebalanceStableBorrowRate(address asset, address user) external;

  /**
   * @dev Allows depositors to enable/disable a specific deposited asset as collateral
   * @param asset The address of the underlying asset deposited
   * @param useAsCollateral `true` if the user wants to use the deposit as collateral, `false` otherwise
   **/
  function setUserUseInstrumentAsCollateral(address asset, bool useAsCollateral) external;

  /**
   * @dev Function to liquidate a non-healthy position collateral-wise, with Health Factor below 1
   * - The caller (liquidator) covers `debtToCover` amount of debt of the user getting liquidated, and receives
   *   a proportionally amount of the `collateralAsset` plus a bonus to cover market risk
   * @param collateralAsset The address of the underlying asset used as collateral, to receive as result of the liquidation
   * @param debtAsset The address of the underlying borrowed asset to be repaid with the liquidation
   * @param user The address of the borrower getting liquidated
   * @param debtToCover The debt amount of borrowed `asset` the liquidator wants to cover
   * @param receiveIToken `true` if the liquidators wants to receive the collateral iTokens, `false` if he wants
   * to receive the underlying collateral asset directly
   **/
  function liquidationCall(address collateralAsset, address debtAsset, address user, uint256 debtToCover, bool receiveIToken) external;

  /**
   * @dev Allows smartcontracts to access the liquidity of the pool within one transaction, as long as the amount taken plus a fee is returned.
   * @param receiverAddress The address of the contract receiving the funds, implementing the IFlashLoanReceiver interface
   * @param asset The addresses of the assets being flash-borrowed
   * @param amount The amounts amounts being flash-borrowed
   * @param _params Variadic packed params to pass to the receiver as extra information
   * @param boosterId of the Booster used to get a discount on the Fee. 0 if no Booster NFT available
   **/
  function flashLoan( address receiverAddress, address asset, uint256 amount, bytes calldata _params, uint16 boosterId) external;

  /**
   * @dev Returns the user account data across all the instruments
   * @param user The address of the user
   * @return totalCollateralUSD the total collateral in USD of the user
   * @return totalDebtUSD the total debt in USD of the user
   * @return availableBorrowsUSD the borrowing power left of the user
   * @return currentLiquidationThreshold the liquidation threshold of the user
   * @return ltv the loan to value of the user
   * @return healthFactor the current health factor of the user
   **/
  function getUserAccountData(address user) external view returns (
      uint256 totalCollateralUSD,
      uint256 totalDebtUSD,
      uint256 availableBorrowsUSD,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );

  function getInstrumentConfiguration(address asset) external view returns ( DataTypes.InstrumentConfigurationMap memory );

  function initInstrument(address asset,address iTokenAddress, address stableDebtAddress, address variableDebtAddress, address interestRateStrategyAddress) external;

  function setInstrumentInterestRateStrategyAddress(address instrument, address rateStrategyAddress) external;

  function setConfiguration(address instrument, uint256 configuration) external;



  /**
   * @dev Returns the configuration of the user across all the instruments
   * @param user The user address
   * @return The configuration of the user
   **/
  function getUserConfiguration(address user) external view returns (DataTypes.UserConfigurationMap memory);

  /**
   * @dev Returns the normalized income normalized income of the instrument
   * @param asset The address of the underlying asset
   * @return The instrument's normalized income
   */
  function getInstrumentNormalizedIncome(address asset) external view returns (uint256);

  /**
   * @dev Returns the normalized variable debt per unit of asset
   * @param asset The address of the underlying asset
   * @return The instrument normalized variable debt
   */
  function getInstrumentNormalizedVariableDebt(address asset) external view returns (uint256);

  /**
   * @dev Returns the state and configuration of the instrument
   * @param asset The address of the underlying asset
   * @return The state of the instrument
   **/
  function getInstrumentData(address asset) external view returns (DataTypes.InstrumentData memory);

  function finalizeTransfer(address asset, address from, address to, uint256 amount, uint256 balanceFromAfter, uint256 balanceToBefore) external;

  function getInstrumentsList() external view returns (address[] memory);

  function setPause(bool val) external;



}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/SIGHContracts/ISIGHVolatilityHarvester.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Distribution Handler Contract
 * @notice Handles the SIGH Loss Minimizing Mechanism for the Lending Protocol
 * @dev Accures SIGH for the supported markets based on losses made every 24 hours, along with Staking speeds. This accuring speed is updated every hour
 * @author SIGH Finance
 */

interface ISIGHVolatilityHarvester {

    function refreshConfig() external;

    function addInstrument( address _instrument, address _iTokenAddress,address _stableDebtToken,address _variableDebtToken, address _sighStreamAddress, uint8 _decimals ) external returns (bool);   // onlyLendingPoolCore
    function removeInstrument( address _instrument ) external returns (bool);   //

    function Instrument_SIGH_StateUpdated(address instrument_, uint _bearSentiment,uint _bullSentiment, bool _isSIGHMechanismActivated  ) external returns (bool); // onlySighFinanceConfigurator

    function updateSIGHSpeed(uint SIGHSpeed_) external returns (bool);                                                      // onlySighFinanceConfigurator
    function updateStakingSpeedForAnInstrument(address instrument_, uint newStakingSpeed) external returns (bool);          // onlySighFinanceConfigurator
    function updateCryptoMarketSentiment(  uint cryptoMarketSentiment_ ) external returns (bool);                      // onlySighFinanceConfigurator
    function updateDeltaTimestampRefresh(uint deltaBlocksLimit) external returns (bool);                               // onlySighFinanceConfigurator
    function updateETHOracleAddress( address _EthOracleAddress ) external returns (bool) ;

    function refreshSIGHSpeeds() external returns (bool);

    function updateSIGHSupplyIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPoolCore
    function updateSIGHBorrowIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPoolCore

    function transferSighTotheUser(address instrument, address user, uint sigh_Amount ) external  returns (uint);             // onlyITokenContract(instrument)

    // ###### VIEW FUNCTIONS ######
    function getSIGHBalance() external view returns (uint);
    function getAllInstrumentsSupported() external view returns (address[] memory );

    function getInstrumentData (address instrument_) external view returns (string memory name, address iTokenAddress, uint decimals, bool isSIGHMechanismActivated,uint256 supplyindex, uint256 borrowindex  );

    function getInstrumentSpeeds(address instrument) external view returns (uint8 side, uint suppliers_speed, uint borrowers_speed, uint staking_speed );
    function getInstrumentVolatilityStates(address instrument) external view returns ( uint8 side, uint _total24HrSentimentVolatility, uint percentTotalSentimentVolatility, uint _total24HrVolatility, uint percentTotalVolatility  );
    function getInstrumentSighLimits(address instrument) external view returns ( uint _bearSentiment , uint _bullSentiment  );

    function getAllPriceSnapshots(address instrument_ ) external view returns (uint256[24] memory);
    function getBlockNumbersForPriceSnapshots() external view returns (uint256[24] memory);

    function getSIGHSpeed() external view returns (uint);
    function getSIGHSpeedUsed() external view returns (uint);

    function isInstrumentSupported (address instrument_) external view returns (bool);
    function totalInstrumentsSupported() external view returns (uint);

    function getInstrumentSupplyIndex(address instrument_) external view returns (uint);
    function getInstrumentBorrowIndex(address instrument_) external view returns (uint);

    function getCryptoMarketSentiment () external view returns (uint);
    function checkPriceSnapshots(address instrument_, uint clock) external view returns (uint256);
    function checkinitializationCounter(address instrument_) external view returns (uint32);

    function getdeltaTimestamp() external view returns (uint);
    function getprevHarvestRefreshTimestamp() external view returns (uint);
    function getBlocksRemainingToNextSpeedRefresh() external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/SIGHContracts/SIGHVolatilityHarvester.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Volatility Harvester Contract
 * @notice Handles the SIGH Loss Minimizing Mechanism for the Lending Protocol
 * @dev Accures SIGH for the supported markets based on losses made every 24 hours, along with Staking speeds. This accuring speed is updated every hour
 * @author _astromartian
 */






contract SIGHVolatilityHarvester is ISIGHVolatilityHarvester, Exponential,  VersionedInitializable {
    
// ######## CONTRACT ADDRESSES ########
    GlobalAddressesProvider public addressesProvider;
    ERC20 public Sigh_Address;
    IPriceOracleGetter public oracle;
    address private Eth_Oracle_Address;
    ILendingPool public lendingPool;

    uint constant sighInitialIndex = 1e36;                              //  The initial SIGH index for an instrument

    Exp private cryptoMarketSentiment = Exp({mantissa: 1e18 });  

    // TOTAL Protocol Volatility Values (Current Session)
    uint256 private last24HrsTotalProtocolVolatility = 0;
    uint256 private last24HrsSentimentProtocolVolatility = 0;
    uint256 private deltaBlockslast24HrSession = 0;
    
    // SIGH Speed is set by SIGH Finance Manager. SIGH Speed Used = Calculated based on "cryptoMarketSentiment" & "last24HrsSentimentProtocolVolatility"
    uint private SIGHSpeed;
    uint private SIGHSpeedUsed;

    address[] private all_Instruments;    // LIST OF INSTRUMENTS 

// ######## INDIVIDUAL INSTRUMENT STATE ########

    struct SupportedInstrument {
        bool isListed;
        bool isSIGHMechanismActivated;
        string symbol;
        uint8 decimals;
        address iTokenAddress;
        address stableDebtToken;
        address variableDebtToken;
        address sighStreamAddress;
        uint supplyindex;
        uint256 supplylastupdatedblock;
        uint borrowindex;
        uint256 borrowlastupdatedblock;
    }

    mapping (address => SupportedInstrument) private crypto_instruments;    // FINANCIAL INSTRUMENTS
    
// ######## 24 HOUR PRICE HISTORY FOR EACH INSTRUMENT AND THE BLOCK NUMBER WHEN THEY WERE TAKEN ########

    struct InstrumentPriceCycle {
        uint256[24] recordedPriceSnapshot;
        uint32 initializationCounter;
    }

    mapping(address => InstrumentPriceCycle) private instrumentPriceCycles;    
    uint256[24] private blockNumbersForPriceSnapshots_;
    uint224 private curClock;
    uint256 private curEpoch;    

// ######## SIGH DISTRIBUTION SPEED FOR EACH INSTRUMENT ########

    struct Instrument_Sigh_Mechansim_State {
        uint8 side;                                          // side = enum{Suppliers,Borrowers,inactive}
        uint256 bearSentiment;                               // Volatility Limit Ratio = bearSentiment (if side == Suppliers)
        uint256 bullSentiment;                               // Volatility Limit Ratio = bearSentiment (if side == Borrowers)
        uint256 _total24HrVolatility;                        // TOTAL VOLATILITY = Total Compounded Balance * Price Difference
        uint256 _total24HrSentimentVolatility;               // Volatility Limit Amount = TOTAL VOLATILITY * (Volatility Limit Ratio) / 1e18
        uint256 percentTotalVolatility;                      // TOTAL VOLATILITY / last24HrsTotalProtocolVolatility
        uint256 percentTotalSentimentVolatility;             // Volatility Limit Amount / last24HrsSentimentProtocolVolatility
        uint256 suppliers_Speed;
        uint256 borrowers_Speed;
        uint256 staking_Speed;
    }

    mapping(address => Instrument_Sigh_Mechansim_State) private Instrument_Sigh_Mechansim_States;
    uint256 private deltaTimestamp = 3600; // 60 * 60 
    uint256 private prevHarvestRefreshTimestamp;


    // ####################################
    // ############## EVENTS ##############
    // ####################################

    event InstrumentAdded (address instrumentAddress_, address iTokenAddress, address sighStreamAddress,  uint8 decimals);
    event InstrumentRemoved(address _instrument);
    event InstrumentSIGHStateUpdated( address instrument_, bool isSIGHMechanismActivated, uint bearSentiment, uint bullSentiment );

    event SIGHSpeedUpdated(uint oldSIGHSpeed, uint newSIGHSpeed);     /// Emitted when SIGH speed is changed
    event CryptoMarketSentimentUpdated( uint cryptoMarketSentiment );
    event minimumTimestampForSpeedRefreshUpdated( uint prevdeltaTimestamp,uint newdeltaTimestamp );
    event EthereumOracleAddressUpdated(address ethOracleAddress);
    event StakingSpeedUpdated(address instrumentAddress_ , uint prevStakingSpeed, uint new_staking_Speed);
    
    event PriceSnapped(address instrument, uint prevPrice, uint currentPrice, uint deltaBlocks, uint currentClock );   
    event MaxSIGHSpeedCalculated(uint _SIGHSpeed, uint _SIGHSpeedUsed, uint _totalVolatilityLimitPerBlock, uint _maxVolatilityToAddressPerBlock, uint _max_SIGHDistributionLimitDecimalsAdjusted );
    event InstrumentVolatilityCalculated(address _Instrument, uint bullSentiment, uint bearSentiment, uint _total24HrVolatility , uint _total24HrSentimentVolatility);
    event refreshingSighSpeeds( address _Instrument, uint8 side,  uint supplierSpeed, uint borrowerSpeed, uint _percentTotalSentimentVolatility, uint _percentTotalVolatility );
    

    event SIGHSupplyIndexUpdated(address instrument, uint totalCompoundedSupply, uint sighAccured, uint ratioMantissa, uint newIndexMantissa);
    event SIGHBorrowIndexUpdated(address instrument, uint totalCompoundedStableBorrows, uint totalCompoundedVariableBorrows, uint sighAccured, uint ratioMantissa, uint newIndexMantissa );

    event AccuredSIGHTransferredToTheUser(address instrument, address user, uint sigh_Amount );

// #######################################################
// ##############        MODIFIERS          ##############
// #######################################################
        
    //only lendingPool can use functions affected by this modifier
    modifier onlyLendingPool {
        require(address(lendingPool) == msg.sender, "The caller must be the Lending pool contract");
        _;
    }   
    
    //only SIGH Distribution Manager can use functions affected by this modifier
    modifier onlySighFinanceConfigurator {
        require(addressesProvider.getSIGHFinanceConfigurator() == msg.sender, "The caller must be the SIGH Finanace Configurator Contract");
        _;
    }

    // This function can only be called by the Instrument's IToken Contract
    modifier onlySighStreamContract(address instrument) {
           SupportedInstrument memory currentInstrument = crypto_instruments[instrument];
           require( currentInstrument.isListed, "This instrument is not supported by SIGH Distribution Handler");
           require( msg.sender == currentInstrument.sighStreamAddress, "This function can only be called by the Instrument's SIGH Streams Handler Contract");
        _;
    }
        
// ######################################################################################
// ##############        PROXY RELATED  & ADDRESSES INITIALIZATION        ###############
// ######################################################################################

    uint256 constant private SIGH_DISTRIBUTION_REVISION = 0x1;

    function getRevision() internal pure override returns(uint256) {
        return SIGH_DISTRIBUTION_REVISION;
    }
    
    function initialize( GlobalAddressesProvider addressesProvider_) public initializer {   // 
        addressesProvider = addressesProvider_;
        refreshConfigInternal(); 
    }

    function refreshConfig() external override onlySighFinanceConfigurator {
        refreshConfigInternal();
    }

    function refreshConfigInternal() internal {
        Sigh_Address = ERC20(addressesProvider.getSIGHAddress());
        oracle = IPriceOracleGetter( addressesProvider.getPriceOracle() );
        lendingPool = ILendingPool(addressesProvider.getLendingPool());
    }
    
    
// #####################################################################################################################################################
// ##############        ADDING INSTRUMENTS AND ENABLING / DISABLING SIGH's LOSS MINIMIZING DISTRIBUTION MECHANISM       ###############################
// ##############        1. addInstrument() : Adds an instrument. Called by LendingPool                              ######################################################
// ##############        2. removeInstrument() : Instrument supported by Sigh Distribution. Called by Sigh Finance Configurator   #####################
// ##############        3. Instrument_SIGH_StateUpdated() : Activate / Deactivate SIGH Mechanism, update Volatility Limits for Suppliers / Borrowers ###############
// #####################################################################################################################################################

    /**
    * @dev adds an instrument - Called by LendingPool Core when an instrument is added to the Lending Protocol
    * @param _instrument the instrument object
    * @param _iTokenAddress the address of the overlying iToken contract
    * @param _decimals the number of decimals of the underlying asset
    **/
    function addInstrument( address _instrument, address _iTokenAddress,address _stableDebtToken,address _variableDebtToken, address _sighStreamAddress, uint8 _decimals ) external override returns (bool) {
        require(addressesProvider.getLendingPoolConfigurator() == msg.sender,'Not Lending Pool Configurator');
        require(!crypto_instruments[_instrument].isListed ,"Instrument already supported.");

        all_Instruments.push(_instrument); // ADD THE INSTRUMENT TO THE LIST OF SUPPORTED INSTRUMENTS
        ERC20 instrumentContract = ERC20(_iTokenAddress);

        // STATE UPDATED : INITIALIZE INNSTRUMENT DATA
        crypto_instruments[_instrument] = SupportedInstrument( {  isListed: true, 
                                                                symbol: instrumentContract.symbol(),
                                                                iTokenAddress: _iTokenAddress,
                                                                stableDebtToken: _stableDebtToken,
                                                                variableDebtToken: _variableDebtToken,
                                                                sighStreamAddress: _sighStreamAddress,
                                                                decimals: uint8(_decimals),
                                                                isSIGHMechanismActivated: false, 
                                                                supplyindex: sighInitialIndex, // ,"sighInitialIndex exceeds 224 bits"), 
                                                                supplylastupdatedblock: getBlockNumber(), 
                                                                borrowindex : sighInitialIndex, //,"sighInitialIndex exceeds 224 bits"), 
                                                                borrowlastupdatedblock : getBlockNumber()
                                                                } );
        // STATE UPDATED : INITITALIZE INSTRUMENT SPEEDS
        Instrument_Sigh_Mechansim_States[_instrument] = Instrument_Sigh_Mechansim_State({ 
                                                            side: uint8(0) ,
                                                            bearSentiment : uint(1e18),
                                                            bullSentiment: uint(1e18),
                                                            suppliers_Speed: uint(0),
                                                            borrowers_Speed: uint(0),
                                                            staking_Speed: uint(0),
                                                            _total24HrVolatility: uint(0),
                                                            _total24HrSentimentVolatility: uint(0),
                                                            percentTotalVolatility: uint(0),
                                                            percentTotalSentimentVolatility: uint(0)
                                                        } );
                                                        

        // STATE UPDATED : INITIALIZE PRICECYCLES
        if ( instrumentPriceCycles[_instrument].initializationCounter == 0 ) {
            uint256[24] memory emptyPrices;
            instrumentPriceCycles[_instrument] = InstrumentPriceCycle({ recordedPriceSnapshot : emptyPrices, initializationCounter: uint32(0) }) ;
        }   

        emit InstrumentAdded(_instrument,_iTokenAddress, _sighStreamAddress,  _decimals);
        return true;
    }

    /**
    * @dev removes an instrument - Called by LendingPool Core when an instrument is removed from the Lending Protocol
    * @param _instrument the instrument object
    **/
    function removeInstrument( address _instrument ) external override onlyLendingPool returns (bool) {
        require(crypto_instruments[_instrument].isListed ,"Instrument already supported.");
        require(updatedInstrumentIndexesInternal(), "Updating Instrument Indexes Failed");       //  accure the indexes 

        uint index = 0;
        uint length_ = all_Instruments.length;
        for (uint i = 0 ; i < length_ ; i++) {
            if (all_Instruments[i] == _instrument) {
                index = i;
                break;
            }
        }
        all_Instruments[index] = all_Instruments[length_ - 1];
        all_Instruments.pop();
        uint newLen = length_ - 1;
        require(all_Instruments.length == newLen,"Instrument not properly removed from the list of instruments supported");
        
        delete crypto_instruments[_instrument];
        delete Instrument_Sigh_Mechansim_States[_instrument];
        delete instrumentPriceCycles[_instrument];

        emit InstrumentRemoved(_instrument);
        return true;
    }



    /**
    * @dev Instrument to be convered under the SIGH DIstribution Mechanism and the associated Volatility Limits - Decided by the SIGH Finance Manager who 
    * can call this function through the Sigh Finance Configurator
    * @param instrument_ the instrument object
    **/
    function Instrument_SIGH_StateUpdated(address instrument_, uint _bearSentiment,uint _bullSentiment, bool _isSIGHMechanismActivated  ) external override onlySighFinanceConfigurator returns (bool) {                   //
        require(crypto_instruments[instrument_].isListed ,"Instrument not supported.");
        require( _bearSentiment >= 0.01e18, 'The new Volatility Limit for Suppliers must be greater than 0.01e18 (1%)');
        require( _bearSentiment <= 10e18, 'The new Volatility Limit for Suppliers must be less than 10e18 (10x)');
        require( _bullSentiment >= 0.01e18, 'The new Volatility Limit for Borrowers must be greater than 0.01e18 (1%)');
        require( _bullSentiment <= 10e18, 'The new Volatility Limit for Borrowers must be less than 10e18 (10x)');
        refreshSIGHSpeeds(); 
        
        crypto_instruments[instrument_].isSIGHMechanismActivated = _isSIGHMechanismActivated;                       // STATE UPDATED
        Instrument_Sigh_Mechansim_States[instrument_].bearSentiment = _bearSentiment;      // STATE UPDATED
        Instrument_Sigh_Mechansim_States[instrument_].bullSentiment = _bullSentiment;      // STATE UPDATED
        
        emit InstrumentSIGHStateUpdated( instrument_, crypto_instruments[instrument_].isSIGHMechanismActivated, Instrument_Sigh_Mechansim_States[instrument_].bearSentiment, Instrument_Sigh_Mechansim_States[instrument_].bullSentiment );
        return true;
    }
    

// ###########################################################################################################################
// ##############        GLOBAL SIGH SPEED AND SIGH SPEED RATIO FOR A MARKET          ########################################
// ##############        1. updateSIGHSpeed() : Governed by Sigh Finance Manager          ####################################
// ##############        3. updateStakingSpeedForAnInstrument():  Decided by the SIGH Finance Manager          ###############
// ##############        5. updatedeltaTimestampRefresh() : Decided by the SIGH Finance Manager           ###############
// ###########################################################################################################################

    /**
     * @notice Sets the amount of Global SIGH distributed per block - - Decided by the SIGH Finance Manager who 
     * can call this function through the Sigh Finance Configurator
     * @param SIGHSpeed_ The amount of SIGH wei per block to distribute
     */
    function updateSIGHSpeed(uint SIGHSpeed_) external override onlySighFinanceConfigurator returns (bool) {
        refreshSIGHSpeeds();
        uint oldSpeed = SIGHSpeed;
        SIGHSpeed = SIGHSpeed_;                                 // STATE UPDATED
        emit SIGHSpeedUpdated(oldSpeed, SIGHSpeed);
        return true;
    }
    
    /**
     * @notice Sets the staking speed for an Instrument - Decided by the SIGH Finance Manager who 
     * can call this function through the Sigh Finance Configurator
     * @param instrument_ The instrument
     * @param newStakingSpeed The additional SIGH staking speed assigned to the Instrument
     */
    function updateStakingSpeedForAnInstrument(address instrument_, uint newStakingSpeed) external override onlySighFinanceConfigurator returns (bool) {     //
        require(crypto_instruments[instrument_].isListed ,"Instrument not supported.");
        
        uint prevStakingSpeed = Instrument_Sigh_Mechansim_States[instrument_].staking_Speed;
        Instrument_Sigh_Mechansim_States[instrument_].staking_Speed = newStakingSpeed;                    // STATE UPDATED

        emit StakingSpeedUpdated(instrument_, prevStakingSpeed, Instrument_Sigh_Mechansim_States[instrument_].staking_Speed);
        return true;
    }


    /**
     * @notice Updates the minimum blocks to be mined before speed can be refreshed again  - Decided by the SIGH Finance Manager who 
     * can call this function through the Sigh Finance Configurator
     * @param deltaTimestampLimit The new Minimum time limit
     */   
    function updateDeltaTimestampRefresh(uint deltaTimestampLimit) external override onlySighFinanceConfigurator returns (bool) {      //
        refreshSIGHSpeeds();
        uint prevdeltaTimestamp = deltaTimestamp;
        deltaTimestamp = deltaTimestampLimit;                                         // STATE UPDATED
        emit minimumTimestampForSpeedRefreshUpdated( prevdeltaTimestamp,deltaTimestamp );
        return true;
    }

    function updateCryptoMarketSentiment( uint cryptoMarketSentiment_ ) external override onlySighFinanceConfigurator returns (bool) {
        require( cryptoMarketSentiment_ >= 0.01e18, 'The new Volatility Limit for Borrowers must be greater than 0.01e18 (1%)');
        require( cryptoMarketSentiment_ <= 10e18, 'The new Volatility Limit for Borrowers must be less than 10e18 (10x)');
        
        cryptoMarketSentiment = Exp({mantissa: cryptoMarketSentiment_ });  
        emit CryptoMarketSentimentUpdated( cryptoMarketSentiment.mantissa );
        return true;
    }

    function updateETHOracleAddress( address _EthOracleAddress ) external override onlySighFinanceConfigurator returns (bool) {
        require( _EthOracleAddress != address(0), 'ETH Oracle address not valid');
        require(oracle.getAssetPrice(_EthOracleAddress) > 0, 'Oracle returned invalid price');   
        require(oracle.getAssetPriceDecimals(_EthOracleAddress) > 0, 'Oracle returned invalid decimals');   
        
        Eth_Oracle_Address = _EthOracleAddress;       
        emit EthereumOracleAddressUpdated( Eth_Oracle_Address );
        return true;
    }

    // #########################################################################################################
    // ################ REFRESH SIGH DISTRIBUTION SPEEDS FOR INSTRUMENTS (INITIALLY EVERY HOUR) ################
    // #########################################################################################################

    /**
     * @notice Recalculate and update SIGH speeds for all Supported SIGH markets
     */
    function refreshSIGHSpeeds() public override returns (bool) {
        uint256 timeElapsedSinceLastRefresh = sub_(block.timestamp , prevHarvestRefreshTimestamp, "Refresh SIGH Speeds : Subtraction underflow for timestamps"); 

        if ( timeElapsedSinceLastRefresh >= deltaTimestamp) {
            refreshSIGHSpeedsInternal();
            prevHarvestRefreshTimestamp = block.timestamp;                                        // STATE UPDATED
            return true;
        }
        return false;
    }



    /**
     * @notice Recalculate and update SIGH speeds for all Supported SIGH markets
     * 1. Instrument indexes for all instruments updated
     * 2. Delta blocks (past 24 hours) calculated and current block number (for price snapshot) updated
     * 3. 1st loop over all instruments --> Average loss (per block) for each of the supported instruments
     *    along with the total lending protocol's loss (per block) calculated and stored price snapshot is updated
     * 4. The Sigh speed that will be used for speed refersh calculated (provided if is needed to be done) 
     * 5. 1st loop over all instruments -->  Sigh Distribution speed (Loss driven speed + staking speed) calculated for 
     *    each instrument
     * 5.1 Current Clock updated
     */    
    function refreshSIGHSpeedsInternal() internal {
        address[] memory all_Instruments_ = all_Instruments;
        uint deltaBlocks_ = sub_( block.timestamp , blockNumbersForPriceSnapshots_[curClock], "DeltaTimestamp resulted in Underflow");       // Delta Blocks over past 24 hours
        blockNumbersForPriceSnapshots_[curClock] = block.timestamp;                                                                    // STATE UPDATE : Block Number for the priceSnapshot Updated

        require(updatedInstrumentIndexesInternal(), "Updating Instrument Indexes Failed");       //  accure the indexes 

        Exp memory totalProtocolVolatility = Exp({mantissa: 0});                            // TOTAL LOSSES (Over past 24 hours)
        Exp memory totalProtocolVolatilityLimit = Exp({mantissa: 0});                            // TOTAL LOSSES (Over past 24 hours)
        
        // Price Snapshot for current clock replaces the pervious price snapshot
        // DELTA BLOCKS = CURRENT BLOCK - 24HRS_OLD_STORED_BLOCK_NUMBER
        // LOSS PER INSTRUMENT = PREVIOUS PRICE (STORED) - CURRENT PRICE (TAKEN FROM ORACLE)
        // TOTAL VOLATILITY OF AN INSTRUMENT = LOSS PER INSTRUMENT * TOTAL COMPOUNDED LIQUIDITY
        // VOLATILITY OF AN INSTRUMENT TO BE ACCOUNTED FOR = TOTAL VOLATILITY OF AN INSTRUMENT * VOLATILITY LIMIT (DIFFERENT FOR SUPPLIERS/BORROWERS OF INSTRUMENT)
        // TOTAL PROTOCOL VOLATILITY =  + ( VOLATILITY OF AN INSTRUMENT TO BE ACCOUNTED FOR )
        for (uint i = 0; i < all_Instruments_.length; i++) {

            address _currentInstrument = all_Instruments_[i];       // Current Instrument
            
            // UPDATING PRICE SNAPSHOTS
            Exp memory previousPriceUSD = Exp({ mantissa: instrumentPriceCycles[_currentInstrument].recordedPriceSnapshot[curClock] });            // 24hr old price snapshot
            Exp memory currentPriceUSD = Exp({ mantissa: oracle.getAssetPrice( _currentInstrument ) });                                            // current price from the oracle
            require ( currentPriceUSD.mantissa > 0, "refreshSIGHSpeedsInternal : Oracle returned Invalid Price" );
            instrumentPriceCycles[_currentInstrument].recordedPriceSnapshot[curClock] =  uint256(currentPriceUSD.mantissa); //  STATE UPDATED : PRICE SNAPSHOT TAKEN        
            emit PriceSnapped(_currentInstrument, previousPriceUSD.mantissa, instrumentPriceCycles[_currentInstrument].recordedPriceSnapshot[curClock], deltaBlocks_, curClock );

            if ( !crypto_instruments[_currentInstrument].isSIGHMechanismActivated || instrumentPriceCycles[_currentInstrument].initializationCounter != uint32(24) ) {     // if LOSS MINIMIZNG MECHANISM IS NOT ACTIVATED FOR THIS INSTRUMENT
                // STATE UPDATE
                Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment = 1e18;
                Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment = 1e18;
                Instrument_Sigh_Mechansim_States[_currentInstrument].side = uint8(0);
                Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility =  uint(0);
                Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility =  uint(0);
                //    Newly Sighed Instrument needs to reach 24 (priceSnapshots need to be taken) before it can be assigned a Sigh Speed based on VOLATILITY   
                if (instrumentPriceCycles[_currentInstrument].initializationCounter < uint32(24) ) {
                    instrumentPriceCycles[_currentInstrument].initializationCounter = uint32(add_(instrumentPriceCycles[_currentInstrument].initializationCounter , uint32(1) , 'Price Counter addition failed.'));  // STATE UPDATE : INITIALIZATION COUNTER UPDATED
                }
            }
            else {
                MathError error;
                Exp memory volatility = Exp({mantissa: 0});
                Exp memory lossPerInstrument = Exp({mantissa: 0});   
                Exp memory instrumentVolatilityLimit = Exp({mantissa: 0});
                
                if ( greaterThanExp(previousPriceUSD , currentPriceUSD) ) {   // i.e the price has decreased so we calculate Losses accured by Suppliers of the Instrument
                    uint totalCompoundedLiquidity = ERC20(crypto_instruments[_currentInstrument].iTokenAddress).totalSupply(); // Total Compounded Liquidity
                    ( error, lossPerInstrument) = subExp( previousPriceUSD , currentPriceUSD );       
                    ( error, volatility ) = mulScalar( lossPerInstrument, totalCompoundedLiquidity );
                    instrumentVolatilityLimit = Exp({mantissa: Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment });
                    // STATE UPDATE
                    Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility =  adjustForDecimalsInternal(volatility.mantissa, crypto_instruments[_currentInstrument].decimals , oracle.getAssetPriceDecimals(_currentInstrument) );
                    Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility =  mul_(Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility , instrumentVolatilityLimit );
                    Instrument_Sigh_Mechansim_States[_currentInstrument].side = uint8(1);

                    uint256 _bear = mul_(Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment,167);
                    _bear = add_(_bear,1e18);
                    Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment = div_(_bear,168);

                    uint256 _bull = mul_(Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment,167);
                    Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment = div_(_bull,168);

                }
                else {                                              // i.e the price has increased so we calculate Losses accured by Borrowers of the Instrument
                    uint totalVariableBorrows = ERC20(crypto_instruments[_currentInstrument].variableDebtToken).totalSupply();
                    uint totalStableBorrows =  ERC20(crypto_instruments[_currentInstrument].stableDebtToken).totalSupply();
                    uint totalCompoundedBorrows =  add_(totalVariableBorrows,totalStableBorrows,'Compounded Borrows Addition gave error'); 
                    ( error, lossPerInstrument) = subExp( currentPriceUSD, previousPriceUSD );       
                    ( error, volatility ) = mulScalar( lossPerInstrument, totalCompoundedBorrows );
                    instrumentVolatilityLimit = Exp({mantissa: Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment });
                    // STATE UPDATE
                    Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility = adjustForDecimalsInternal(volatility.mantissa , crypto_instruments[_currentInstrument].decimals , oracle.getAssetPriceDecimals(_currentInstrument) );
                    Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility =  mul_(Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility , instrumentVolatilityLimit );
                    Instrument_Sigh_Mechansim_States[_currentInstrument].side = uint8(2);

                    uint256 _bull = mul_(Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment,167);
                    _bull = add_(_bull,1e18);
                    Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment = div_(_bull,168);

                    uint256 _bear = mul_(Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment,167);
                    Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment = div_(_bear,168);

                }
                //  Total Protocol Volatility  += Instrument Volatility 
                totalProtocolVolatility = add_(totalProtocolVolatility, Exp({mantissa: Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility}) );            
                //  Total Protocol Volatility Limit  += Instrument Volatility Limit Amount                 
                 totalProtocolVolatilityLimit = add_(totalProtocolVolatilityLimit, Exp({mantissa: Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility})) ;            
            }
            
            emit InstrumentVolatilityCalculated(_currentInstrument, Instrument_Sigh_Mechansim_States[_currentInstrument].bullSentiment, Instrument_Sigh_Mechansim_States[_currentInstrument].bearSentiment, Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility , Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility);
        }
        
       
        last24HrsTotalProtocolVolatility = totalProtocolVolatility.mantissa;              // STATE UPDATE : Last 24 Hrs Protocol Volatility  (i.e SUM(_total24HrVolatility for Instruments))  Updated
        last24HrsSentimentProtocolVolatility = totalProtocolVolatilityLimit.mantissa;     // STATE UPDATE : Last 24 Hrs Protocol Volatility Limit (i.e SUM(_total24HrSentimentVolatility for Instruments)) Updated
        deltaBlockslast24HrSession = deltaBlocks_;                                        // STATE UPDATE :
        
        // STATE UPDATE :: CALCULATING SIGH SPEED WHICH IS TO BE USED FOR CALCULATING EACH INSTRUMENT's SIGH DISTRIBUTION SPEEDS
        SIGHSpeedUsed = SIGHSpeed;

        (MathError error, Exp memory totalVolatilityLimitPerBlock) = divScalar(Exp({mantissa: last24HrsSentimentProtocolVolatility }) , deltaBlocks_);   // Total Volatility per Block
        calculateMaxSighSpeedInternal( totalVolatilityLimitPerBlock.mantissa ); 
        
        // ###### Updates the Speed (Volatility Driven) for the Supported Instruments ######
        updateSIGHDistributionSpeeds();
        require(updateCurrentClockInternal(), "Updating CLock Failed");                         // Updates the Clock    
    }


    //  Updates the Supply & Borrow Indexes for all the Supported Instruments
    function updatedInstrumentIndexesInternal() internal returns (bool) {
        for (uint i = 0; i < all_Instruments.length; i++) {
            address currentInstrument = all_Instruments[i];
            updateSIGHSupplyIndexInternal(currentInstrument);
            updateSIGHBorrowIndexInternal(currentInstrument);
        }
        return true;
    }
    
    // UPDATES SIGH DISTRIBUTION SPEEDS
    function updateSIGHDistributionSpeeds() internal returns (bool) {
        
        for (uint i=0 ; i < all_Instruments.length ; i++) {

            address _currentInstrument = all_Instruments[i];       // Current Instrument
            Exp memory limitVolatilityRatio =  Exp({mantissa: 0});
            Exp memory totalVolatilityRatio =  Exp({mantissa: 0});
            MathError error;
            
            if ( last24HrsSentimentProtocolVolatility > 0 && Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility > 0 ) {
                ( error, limitVolatilityRatio) = getExp(Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrSentimentVolatility, last24HrsSentimentProtocolVolatility);
                ( error, totalVolatilityRatio) = getExp(Instrument_Sigh_Mechansim_States[_currentInstrument]._total24HrVolatility, last24HrsTotalProtocolVolatility);
                // CALCULATING $SIGH SPEEDS
                if (Instrument_Sigh_Mechansim_States[_currentInstrument].side == uint8(1) ) {
                    // STATE UPDATE
                    Instrument_Sigh_Mechansim_States[_currentInstrument].suppliers_Speed = mul_(SIGHSpeedUsed, limitVolatilityRatio);                                         
                    Instrument_Sigh_Mechansim_States[_currentInstrument].borrowers_Speed = uint(0);                                                           
                } 
                else if  (Instrument_Sigh_Mechansim_States[_currentInstrument].side == uint8(2) )  {
                    // STATE UPDATE
                    Instrument_Sigh_Mechansim_States[_currentInstrument].borrowers_Speed = mul_(SIGHSpeedUsed, limitVolatilityRatio);                                       
                    Instrument_Sigh_Mechansim_States[_currentInstrument].suppliers_Speed = uint(0);                                                          
                }
            } 
            else {
                    // STATE UPDATE
                Instrument_Sigh_Mechansim_States[_currentInstrument].borrowers_Speed = uint(0);                                                               
                Instrument_Sigh_Mechansim_States[_currentInstrument].suppliers_Speed = uint(0);                                                                
            }

            Instrument_Sigh_Mechansim_States[_currentInstrument].percentTotalSentimentVolatility = mul_(10**9, limitVolatilityRatio);                                              // STATE UPDATE (LOss Ratio is instrumentVolatility/totalVolatility * 100000 )
            Instrument_Sigh_Mechansim_States[_currentInstrument].percentTotalVolatility = mul_(10**9, totalVolatilityRatio);                                              // STATE UPDATE (LOss Ratio is instrumentVolatility/totalVolatility * 100000 )
            emit refreshingSighSpeeds( _currentInstrument, Instrument_Sigh_Mechansim_States[_currentInstrument].side,  Instrument_Sigh_Mechansim_States[_currentInstrument].suppliers_Speed, Instrument_Sigh_Mechansim_States[_currentInstrument].borrowers_Speed, Instrument_Sigh_Mechansim_States[_currentInstrument].percentTotalSentimentVolatility, Instrument_Sigh_Mechansim_States[_currentInstrument].percentTotalVolatility );
        }
        return true;
    }





    // returns the currently maximum possible SIGH Distribution speed. Called only when upper check is activated
    // Updated the Global "SIGHSpeedUsed" Variable & "last24HrsSentimentProtocolVolatilityAddressedPerBlock" Variable
    function calculateMaxSighSpeedInternal( uint totalVolatilityLimitPerBlock ) internal {

        uint current_Sigh_PriceETH = oracle.getAssetPrice( address(Sigh_Address) );   
        uint sighEthPriceDecimals = oracle.getAssetPriceDecimals(address(Sigh_Address));
        require(current_Sigh_PriceETH > 0,"Oracle returned invalid $SIGH Price!");

        uint current_ETH_PriceUSD = oracle.getAssetPrice( address(Eth_Oracle_Address) );   
        uint ethPriceDecimals = oracle.getAssetPriceDecimals(address(Eth_Oracle_Address));
        require(current_ETH_PriceUSD > 0,"Oracle returned invalid ETH Price!");

        uint currentSIGH_price_USD = mul_( current_Sigh_PriceETH, current_ETH_PriceUSD);
        currentSIGH_price_USD = div_( currentSIGH_price_USD, uint( 10**(sighEthPriceDecimals) ), "Max Volatility : SIGH decimal Division gave error");

        ERC20 sighContract = ERC20(address(Sigh_Address));
        uint sighDecimals =  sighContract.decimals();

        // MAX Value that can be distributed per block through SIGH Distribution
        uint max_SIGHDistributionLimit = mul_( currentSIGH_price_USD, SIGHSpeed );   
        uint max_SIGHDistributionLimitDecimalsAdjusted = adjustForDecimalsInternal( max_SIGHDistributionLimit, sighDecimals , ethPriceDecimals  );

        // MAX Volatility that is allowed to be covered through SIGH Distribution (% of the Harvestable Volatility)
        uint maxVolatilityToAddressPerBlock = mul_(totalVolatilityLimitPerBlock, cryptoMarketSentiment ); // (a * b)/1e18 [b is in Exp Scale]


        if ( max_SIGHDistributionLimitDecimalsAdjusted >  maxVolatilityToAddressPerBlock ) {
            uint maxVolatilityToAddress_SIGHdecimalsMul = mul_( maxVolatilityToAddressPerBlock, uint(10**(sighDecimals)), "Max Volatility : SIGH Decimals multiplication gave error" );
            uint maxVolatilityToAddress_PricedecimalsMul = mul_( maxVolatilityToAddress_SIGHdecimalsMul, uint(10**(ethPriceDecimals)), "Max Volatility : Price Decimals multiplication gave error" );
            uint maxVolatilityToAddress_DecimalsDiv = div_( maxVolatilityToAddress_PricedecimalsMul, uint(10**18), "Max Volatility : Decimals division gave error" );
            SIGHSpeedUsed = div_( maxVolatilityToAddress_DecimalsDiv, currentSIGH_price_USD, "Max Speed division gave error" );
        }

        emit MaxSIGHSpeedCalculated(SIGHSpeed, SIGHSpeedUsed, totalVolatilityLimitPerBlock, maxVolatilityToAddressPerBlock, max_SIGHDistributionLimitDecimalsAdjusted  );
    }


    // Updates the Current CLock (global variable tracking the current hour )
    function updateCurrentClockInternal() internal returns (bool) {
        curClock = curClock == 23 ? 0 : uint224(add_(curClock,1,"curClock : Addition Failed"));
        return true;
    }

    
    function adjustForDecimalsInternal(uint _amount, uint instrumentDecimals, uint priceDecimals) internal pure returns (uint) {
        require(instrumentDecimals > 0, "Instrument Decimals cannot be Zero");
        require(priceDecimals > 0, "Oracle returned invalid price Decimals");
        uint adjused_Amount = mul_(_amount,uint(10**18),'Loss Amount multiplication Adjustment overflow');
        uint instrumentDecimalsCorrected = div_( adjused_Amount,uint(10**instrumentDecimals),'Instrument Decimals correction underflow');
        uint priceDecimalsCorrected = div_( instrumentDecimalsCorrected,uint(10**priceDecimals),'Price Decimals correction underflow');
        return priceDecimalsCorrected;
    }


    // #####################################################################################################################################
    // ################ UPDATE SIGH DISTRIBUTION INDEXES (Called from LendingPool) #####################################################
    // ################ 1. updateSIGHSupplyIndex() : Called by LendingPool              ################################################
    // ################ --> updateSIGHSupplyIndexInternal() Internal function with actual implementation  ################################## 
    // ################ 2. updateSIGHBorrowIndex() : Called by LendingPool #############################################################
    // ################ --> updateSIGHBorrowIndexInternal() : Internal function with actual implementation #################################
    // #####################################################################################################################################


    /**
     * @notice Accrue SIGH to the Instrument by updating the supply index
     * @param currentInstrument The Instrument whose supply index to update
     */
    function updateSIGHSupplyIndex(address currentInstrument) external override onlyLendingPool returns (bool) { //     // Called on each Deposit, Redeem and Liquidation (collateral)
        require(crypto_instruments[currentInstrument].isListed ,"Instrument not supported.");
        require(updateSIGHSupplyIndexInternal( currentInstrument ), "Updating Sigh Supply Indexes operation failed" );
        return true;
    }

    function updateSIGHSupplyIndexInternal(address currentInstrument) internal returns (bool) {
        uint blockNumber = getBlockNumber();

        if ( crypto_instruments[currentInstrument].supplylastupdatedblock == blockNumber ) {    // NO NEED TO ACCUR AGAIN
            return true;
        }

        SupportedInstrument storage instrumentState = crypto_instruments[currentInstrument];
        uint supplySpeed = add_(Instrument_Sigh_Mechansim_States[currentInstrument].suppliers_Speed, Instrument_Sigh_Mechansim_States[currentInstrument].staking_Speed,"Supplier speed addition with staking speed overflow" );
        uint deltaBlocks = sub_(blockNumber, uint( instrumentState.supplylastupdatedblock ), 'updateSIGHSupplyIndex : Block Subtraction Underflow');    // Delta Blocks 
        
        // WE UPDATE INDEX ONLY IF $SIGH IS ACCURING
        if (deltaBlocks > 0 && supplySpeed > 0) {       // In case SIGH would have accured
            uint sigh_Accrued = mul_(deltaBlocks, supplySpeed);                                                                         // SIGH Accured
            uint totalCompoundedLiquidity = ERC20(crypto_instruments[currentInstrument].iTokenAddress).totalSupply();                           // Total amount supplied 
            Double memory ratio = totalCompoundedLiquidity > 0 ? fraction(sigh_Accrued, totalCompoundedLiquidity) : Double({mantissa: 0});    // SIGH Accured per Supplied Instrument Token
            Double memory newIndex = add_(Double({mantissa: instrumentState.supplyindex}), ratio);                                      // Updated Index
            emit SIGHSupplyIndexUpdated( currentInstrument, totalCompoundedLiquidity, sigh_Accrued, ratio.mantissa , newIndex.mantissa);

            instrumentState.supplyindex = newIndex.mantissa;       // STATE UPDATE: New Index Committed to Storage 
        } 
        
        instrumentState.supplylastupdatedblock = blockNumber ;     // STATE UPDATE: Block number updated        
        return true;
    }



    /**
     * @notice Accrue SIGH to the market by updating the borrow index
     * @param currentInstrument The market whose borrow index to update
     */
    function updateSIGHBorrowIndex(address currentInstrument) external override onlyLendingPool returns (bool) {  //     // Called during Borrow, repay, SwapRate, Rebalance, Liquidation
        require(crypto_instruments[currentInstrument].isListed ,"Instrument not supported.");
        require( updateSIGHBorrowIndexInternal(currentInstrument), "Updating Sigh Borrow Indexes operation failed" ) ;
        return true;
    }

    function updateSIGHBorrowIndexInternal(address currentInstrument) internal returns(bool) {
        uint blockNumber = getBlockNumber();

        if ( crypto_instruments[currentInstrument].borrowlastupdatedblock == blockNumber ) {    // NO NEED TO ACCUR AGAIN
            return true;
        }

        SupportedInstrument storage instrumentState = crypto_instruments[currentInstrument];
        uint borrowSpeed = add_(Instrument_Sigh_Mechansim_States[currentInstrument].borrowers_Speed, Instrument_Sigh_Mechansim_States[currentInstrument].staking_Speed, "Supplier speed addition with staking speed overflow" );
        uint deltaBlocks = sub_(blockNumber, uint(instrumentState.borrowlastupdatedblock), 'updateSIGHBorrowIndex : Block Subtraction Underflow');         // DELTA BLOCKS
        
        uint totalVariableBorrows =   ERC20(crypto_instruments[currentInstrument].variableDebtToken).totalSupply();
        uint totalStableBorrows =   ERC20(crypto_instruments[currentInstrument].stableDebtToken).totalSupply();
        uint totalCompoundedBorrows =  add_(totalVariableBorrows,totalStableBorrows,'Compounded Borrows Addition gave error'); 
        
        if (deltaBlocks > 0 && borrowSpeed > 0) {       // In case SIGH would have accured
            uint sigh_Accrued = mul_(deltaBlocks, borrowSpeed);                             // SIGH ACCURED = DELTA BLOCKS x SIGH SPEED (BORROWERS)
            Double memory ratio = totalCompoundedBorrows > 0 ? fraction(sigh_Accrued, totalCompoundedBorrows) : Double({mantissa: 0});      // SIGH Accured per Borrowed Instrument Token
            Double memory newIndex = add_(Double({mantissa: instrumentState.borrowindex}), ratio);                      // New Index
            emit SIGHBorrowIndexUpdated( currentInstrument, totalStableBorrows, totalVariableBorrows, sigh_Accrued, ratio.mantissa , newIndex.mantissa );

            instrumentState.borrowindex = newIndex.mantissa ;  // STATE UPDATE: New Index Committed to Storage 
        } 

        instrumentState.borrowlastupdatedblock = blockNumber;   // STATE UPDATE: Block number updated        
        return true;
    }

    // #########################################################################################
    // ################### TRANSFERS THE SIGH TO THE MARKET PARTICIPANT  ###################
    // #########################################################################################

    /**
     * @notice Transfer SIGH to the user. Called by the corresponding IToken Contract of the instrument
     * @dev Note: If there is not enough SIGH, we do not perform the transfer call.
     * @param instrument The instrument for which the SIGH has been accured
     * @param user The address of the user to transfer SIGH to
     * @param sigh_Amount The amount of SIGH to (possibly) transfer
     * @return The amount of SIGH which was NOT transferred to the user
     */
    function transferSighTotheUser(address instrument, address user, uint sigh_Amount ) external override onlySighStreamContract(instrument) returns (uint) {   //
        uint sigh_not_transferred = 0;
        if ( Sigh_Address.balanceOf(address(this)) > sigh_Amount ) {   // NO SIGH TRANSFERRED IF CONTRACT LACKS REQUIRED SIGH AMOUNT
            require(Sigh_Address.transfer( user, sigh_Amount ), "Failed to transfer accured SIGH to the user." );
            emit AccuredSIGHTransferredToTheUser( instrument, user, sigh_Amount );
        }
        else {
            sigh_not_transferred = sigh_Amount;
        }
        return sigh_not_transferred;
    }

    // #########################################################
    // ################### GENERAL PARAMETER FUNCTIONS ###################
    // #########################################################

    function getSIGHBalance() public view override returns (uint) {
        uint sigh_Remaining = Sigh_Address.balanceOf(address(this));
        return sigh_Remaining;
    }

    function getAllInstrumentsSupported() external view override returns (address[] memory ) {
        return all_Instruments; 
    }
    
    function getInstrumentData (address instrument_) external override view returns (string memory symbol, address iTokenAddress, uint decimals, bool isSIGHMechanismActivated,uint256 supplyindex, uint256 borrowindex  ) {
        return ( crypto_instruments[instrument_].symbol,
                 crypto_instruments[instrument_].iTokenAddress,    
                 crypto_instruments[instrument_].decimals,    
                 crypto_instruments[instrument_].isSIGHMechanismActivated,
                 crypto_instruments[instrument_].supplyindex,
                 crypto_instruments[instrument_].borrowindex
                ); 
    }

    function getInstrumentSpeeds(address instrument) external override view returns ( uint8 side, uint suppliers_speed, uint borrowers_speed, uint staking_speed ) {
        return ( Instrument_Sigh_Mechansim_States[instrument].side,
                 Instrument_Sigh_Mechansim_States[instrument].suppliers_Speed, 
                 Instrument_Sigh_Mechansim_States[instrument].borrowers_Speed , 
                 Instrument_Sigh_Mechansim_States[instrument].staking_Speed
                );
    }
    
    function getInstrumentVolatilityStates(address instrument) external override view returns ( uint8 side, uint _total24HrSentimentVolatility, uint percentTotalSentimentVolatility, uint _total24HrVolatility, uint percentTotalVolatility  ) {
        return (Instrument_Sigh_Mechansim_States[instrument].side,
                Instrument_Sigh_Mechansim_States[instrument]._total24HrSentimentVolatility,
                Instrument_Sigh_Mechansim_States[instrument].percentTotalSentimentVolatility,
                Instrument_Sigh_Mechansim_States[instrument]._total24HrVolatility,
                Instrument_Sigh_Mechansim_States[instrument].percentTotalVolatility
                );
    }    

    function getInstrumentSighLimits(address instrument) external override view returns ( uint _bearSentiment , uint _bullSentiment ) {
    return ( Instrument_Sigh_Mechansim_States[instrument].bearSentiment, Instrument_Sigh_Mechansim_States[instrument].bullSentiment );
    }

    function getAllPriceSnapshots(address instrument_ ) external override view returns (uint256[24] memory) {
        return instrumentPriceCycles[instrument_].recordedPriceSnapshot;
    }
    
    function getBlockNumbersForPriceSnapshots() external override view returns (uint256[24] memory) {
        return blockNumbersForPriceSnapshots_;
    }

    function getSIGHSpeed() external override view returns (uint) {
        return SIGHSpeed;
    }

    function getSIGHSpeedUsed() external override view returns (uint) {
        return SIGHSpeedUsed;
    }


    function isInstrumentSupported (address instrument_) external override view returns (bool) {
        return crypto_instruments[instrument_].isListed;
    } 

    function totalInstrumentsSupported() external override view returns (uint) {
        return uint(all_Instruments.length); 
    }    

    function getInstrumentSupplyIndex(address instrument_) external override view returns (uint) {
        if (crypto_instruments[instrument_].isListed) { //"The provided instrument address is not supported");
            return crypto_instruments[instrument_].supplyindex;
        }
        return uint(0);
    }

    function getInstrumentBorrowIndex(address instrument_) external override view returns (uint) {
        if (crypto_instruments[instrument_].isListed) { //,"The provided instrument address is not supported");
            return crypto_instruments[instrument_].borrowindex;
        }
        return uint(0);
    }


    function getCryptoMarketSentiment () external override view returns (uint) {
        return cryptoMarketSentiment.mantissa;
    } 

    function checkPriceSnapshots(address instrument_, uint clock) external override view returns (uint256) {
        return instrumentPriceCycles[instrument_].recordedPriceSnapshot[clock];
    }
    
    function checkinitializationCounter(address instrument_) external override view returns (uint32) {
        return instrumentPriceCycles[instrument_].initializationCounter;
    }

    function getdeltaTimestamp() external override view returns (uint) {
        return deltaTimestamp;
    }  

    function getprevHarvestRefreshTimestamp() external override view returns (uint) {
        return prevHarvestRefreshTimestamp;
    }  

    function getBlocksRemainingToNextSpeedRefresh() external override view returns (uint) {
        uint blocksElapsed = sub_(block.number,prevHarvestRefreshTimestamp); 
        if ( deltaTimestamp > blocksElapsed) {
            return sub_(deltaTimestamp,blocksElapsed);
        }
        return uint(0);
    }

    function getLast24HrsTotalProtocolVolatility() external view returns (uint) {
        return last24HrsTotalProtocolVolatility;
    }

    function getLast24HrsTotalSentimentProtocolVolatility() external view returns (uint) {
        return last24HrsSentimentProtocolVolatility;
    }
    
    function getdeltaBlockslast24HrSession() external view returns (uint) {
        return deltaBlockslast24HrSession;
    }

    function getBlockNumber() public view returns (uint32) {
        return uint32(block.number);
    }
    
    

}
