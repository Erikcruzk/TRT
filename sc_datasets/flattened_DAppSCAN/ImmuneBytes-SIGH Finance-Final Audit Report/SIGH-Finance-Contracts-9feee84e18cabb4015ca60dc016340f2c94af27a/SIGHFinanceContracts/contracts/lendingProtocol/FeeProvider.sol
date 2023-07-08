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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20Detailed.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @dev Optional functions from the ERC20 standard.
 */
interface IERC20Detailed {


    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory) ;

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory) ;

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() external view returns (uint8) ;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/PercentageMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title PercentageMath library
 * @author Aave
 * @notice Provides functions to perform percentage calculations
 * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
 * @dev Operations are rounded half up
 **/

library PercentageMath {
    uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
    uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;

    /**
    * @dev Executes a percentage multiplication
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return The percentage of value
    **/
    function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
        if (value == 0 || percentage == 0) {
            return 0;
        }

        require(value <= (type(uint256).max - HALF_PERCENT) / percentage, "Percentage Math : Multiplication error" );
        return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
    }

    /**
    * @dev Executes a percentage division
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return The value divided the percentage
    **/
    function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
        require(percentage != 0, "MATH DIVISION BY ZERO");
        uint256 halfPercentage = percentage / 2;

        require( value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR, "Percentage Math : Division error" );
        return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
    }
}

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/NFTBoosters/ISIGHBoosters.sol

// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity ^0.7.0;

interface ISIGHBoosters {

    // ########################
    // ######## EVENTS ########
    // ########################

    event baseURIUpdated(string baseURI);
    event newCategoryAdded(string _type, uint256 _platformFeeDiscount_, uint256 _sighPayDiscount_);
    event BoosterMinted(address _owner, string _type,string boosterURI,uint256 newItemId,uint256 totalBoostersOfThisCategory);
    event boosterURIUpdated(uint256 boosterId, string _boosterURI);
    event discountMultiplierUpdated(string _type,uint256 _platformFeeDiscount_,uint256 _sighPayDiscount_ );

    event BoosterWhiteListed(uint256 boosterId);
    event BoosterBlackListed(uint256 boosterId);

    // #################################
    // ######## ADMIN FUNCTIONS ########
    // #################################
    
    function addNewBoosterType(string memory _type, uint256 _platformFeeDiscount_, uint256 _sighPayDiscount_) external returns (bool) ;
    function createNewBoosters(string[] memory _type,  string[] memory boosterURI) external returns (uint256);
    function createNewSIGHBooster(address _owner, string memory _type,  string memory boosterURI, bytes memory _data ) external returns (uint256) ;
    function _updateBaseURI(string memory baseURI )  external ;
    function updateBoosterURI(uint256 boosterId, string memory boosterURI )  external returns (bool) ;
    function updateDiscountMultiplier(string memory _type, uint256 _platformFeeDiscount_,uint256 _sighPayDiscount_)  external returns (bool) ;

    function blackListBooster(uint256 boosterId) external;
    function whiteListBooster(uint256 boosterId) external;
    // ###########################################
    // ######## STANDARD ERC721 FUNCTIONS ########
    // ###########################################

    function name() external view  returns (string memory) ;
    function symbol() external view  returns (string memory) ;
    function totalSupply() external view  returns (uint256) ;
    function baseURI() external view returns (string memory) ;

    function tokenByIndex(uint256 index) external view  returns (uint256) ;

    function balanceOf(address _owner) external view returns (uint256 balance) ;    // Returns total number of Boosters owned by the _owner
    function tokenOfOwnerByIndex(address owner, uint256 index) external view  returns (uint256) ; //  See {IERC721Enumerable-tokenOfOwnerByIndex}.

    function ownerOfBooster(uint256 boosterId) external view returns (address owner) ; // Returns current owner of the Booster having the ID = boosterId
    function tokenURI(uint256 boosterId) external view  returns (string memory) ;   // Returns the boostURI for the Booster

    function approve(address to, uint256 boosterId) external ;  // A BOOSTER owner can approve anyone to be able to transfer the underlying booster
    function setApprovalForAll(address operator, bool _approved) external;


    function getApproved(uint256 boosterId) external view  returns (address);   // Returns the Address currently approved for the Booster with ID = boosterId
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function transferFrom(address from, address to, uint256 boosterId) external;
    function safeTransferFrom(address from, address to, uint256 boosterId) external;
    function safeTransferFrom(address from, address to, uint256 boosterId, bytes memory data) external;

    // #############################################################
    // ######## FUNCTIONS SPECIFIC TO SIGH FINANCE BOOSTERS ########
    // #############################################################

    function getAllBoosterTypes() external view returns (string[] memory);

    function isCategorySupported(string memory _category) external view returns (bool);
    function getDiscountRatiosForBoosterCategory(string memory _category) external view returns ( uint platformFeeDiscount, uint sighPayDiscount );

    function totalBoostersAvailable(string memory _category) external view returns (uint256);

    function totalBoostersOwnedOfType(address owner, string memory _category) external view returns (uint256) ;  // Returns the number of Boosters of a particular category owned by the owner address

    function isValidBooster(uint256 boosterId) external view returns (bool);
    function getBoosterCategory(uint256 boosterId) external view returns ( string memory boosterType );
    function getDiscountRatiosForBooster(uint256 boosterId) external view returns ( uint platformFeeDiscount, uint sighPayDiscount );
    function getBoosterInfo(uint256 boosterId) external view returns (address farmer, string memory boosterType,uint platformFeeDiscount, uint sighPayDiscount );

    function isBlacklisted(uint boosterId) external view returns(bool) ;
//     function getAllBoosterTypesSupported() external view returns (string[] memory) ;

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IFeeProvider.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
* @title FeeProvider contract Interface
* @notice Implements calculation for the fees applied by the protocol based on the Boosters
* @author SIGH Finance (_astromartian)
**/
interface IFeeProvider  {

    event depositFeePercentUpdated(uint _depositFeePercent);
    event borrowFeePercentUpdated(uint totalBorrowFeePercent_);
    event flashLoanFeePercentUpdated(uint totalFlashLoanFeePercent_);
    event platformFeePercentUpdated(uint _platformFeePercent);

    event initalFuelForABoosterCategoryUpdated(string categoryName,uint initialFuel);
    event topUpOptionUpdated(string category, uint optionNo,uint _fee, uint _multiplier);
    event tokenForPaymentUpdated(address prevToken,address tokenAccepted);
    event tokensTransferred(address token, address destination, uint amount,uint newBalance );

    event _boosterTopUp( uint boosterID,uint optionNo,uint amount,uint topUp,uint totalFuelRemaining);


// ###############################
// ###### PROXY RELATED ##########
// ###############################

    function refreshConfiguration() external returns (bool);

// ###############################################################################################
// ###### EXTERNAL FUNCTIONS TO CALCULATE THE FEE (Can only be called by LendingPool) ############
// ###### 1. calculateDepositFee() ##########
// ###### 2. calculateFlashLoanFee() #######################################
// ###### 1. calculateBorrowFee() ##########
// ################################################################################################

    function calculateDepositFee(address _user,address instrument, uint256 _amount, uint boosterId) external returns (uint256 ,uint256 ,uint256 );
    function calculateBorrowFee(address _user, address instrument, uint256 _amount, uint boosterId) external returns (uint256 platformFee, uint256 reserveFee) ;
    function calculateFlashLoanFee(address _user, uint256 _amount, uint boosterId) external view returns (uint256 ,uint256 ,uint256 ) ;


// #################################
// ####### FUNCTIONS TO INCREASE FUEL LIMIT  ########
// #################################

    function fuelTopUp(uint optionNo, uint boosterID) external ;


// #################################
// ####### ADMIN FUNCTIONS  ########
// #################################

    function updateTotalDepositFeePercent(uint _depositFeePercent) external returns (bool) ;
    function updateTotalBorrowFeePercent(uint totalBorrowFeePercent_) external returns (bool) ;
    function updateTotalFlashLoanFeePercent(uint totalFlashLoanFeePercent_ ) external returns (bool) ;
    function updatePlatformFeePercent(uint _platformFeePercent) external returns (bool);

    function UpdateABoosterCategoryFuelAmount(string calldata categoryName, uint initialFuel ) external returns (bool);
    function updateATopUpOption(string calldata category, uint optionNo, uint _fee, uint _multiplier) external returns (bool) ;

    function updateTokenAccepted(address _token) external  returns (bool) ;
    function transferFunds(address token, address destination, uint amount) external returns (bool) ;

// ###############################
// ####### EXTERNAL VIEW  ########
// ###############################

    function getBorrowFeePercentage() external view returns (uint256) ;
    function getDepositFeePercentage() external view returns (uint256) ;
    function getFlashLoanFeePercentage() external view returns (uint256) ;

    function getFuelAvailable(uint boosterID) external view returns (uint256) ;
    function getFuelUsed(uint boosterID) external view returns (uint256) ;
    function getOptionDetails(string calldata category, uint optionNo) external view returns (uint fee, uint multiplier) ;

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/FeeProvider.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;










/**
* @title FeeProvider contract
* @notice Implements calculation for the fees applied by the protocol
* @author Aave, SIGH Finance
**/
contract FeeProvider is IFeeProvider, VersionedInitializable {

    using PercentageMath for uint256;
    using SafeMath for uint256;

    IGlobalAddressesProvider private globalAddressesProvider;
    IPriceOracleGetter private priceOracle ;
    ISIGHBoosters private SIGH_Boosters;

    uint256 public totalFlashLoanFeePercent;        // Flash Loan Fee 
    uint256 public totalBorrowFeePercent;           // Borrow Fee
    uint256 public totalDepositFeePercent;          // Deposit Fee
    uint256 public platformFeePercent;              // Platform Fee (% of the Borrow Fee / Deposit Fee)

    address private tokenAccepted; 

    mapping (string => uint) initialFuelAmount;  // Initial Fuel the boosters of a particular category have


    struct optionType{
        uint256 fee;                // Fee Charged for this option
        uint256 multiplier;         // Fuel multiplier (fuel top up = fee * multiplier). It is adjusted by 2 decimal places.
                                    // Eq, multiplier = 120, means fuelTopUp = fee * 120/100 = 1.2 * Fee
    }

    mapping (string => mapping (uint => optionType) ) private fuelTopUpOptions; // BoosterType => ( optionNo => optionType )

    struct booster{
        bool initiated;                // To check if this booster has ever been used or not
        uint256 totalFuelRemaining;     // Current Amount of fuel available
        uint256 totalFuelUsed;          // Total Fuel used
    }

    mapping (uint256 => booster) private boosterFuelInfo;    // boosterID => Fuel Remaining (Remaining Volume on which discount will be given) Mapping


    //only SIGH Distribution Manager can use functions affected by this modifier
    modifier onlySighFinanceConfigurator {
        require(globalAddressesProvider.getSIGHFinanceConfigurator() == msg.sender, "The caller must be the SIGH Finance Configurator");
        _;
    }

    //only LendingPool contract can call these functions
    modifier onlyLendingPool {
        require(globalAddressesProvider.getLendingPool() == msg.sender, "The caller must be the Lending Pool Contract");
        _;
    }

// ###############################
// ###### PROXY RELATED ##########
// ###############################

    uint256 constant public FEE_PROVIDER_REVISION = 0x1;

    function getRevision() internal pure override returns(uint256) {
        return FEE_PROVIDER_REVISION;
    }
    /**
    * @dev initializes the FeeProvider after it's added to the proxy
    * @param _addressesProvider the address of the GlobalAddressesProvider
    */
    function initialize(address _addressesProvider) public initializer {
        globalAddressesProvider = IGlobalAddressesProvider(_addressesProvider);
        totalDepositFeePercent = 50;            // deposit fee = 0.5%
        totalFlashLoanFeePercent = 5;           // Flash loan fee = 0.05%
        totalBorrowFeePercent =  50;            // borrow fee = 0.5%
        platformFeePercent = 5000;              // = 50% of total Fee
    }

    function refreshConfiguration() external override onlySighFinanceConfigurator returns (bool) {
        priceOracle = IPriceOracleGetter(globalAddressesProvider.getPriceOracle());
        SIGH_Boosters = ISIGHBoosters(globalAddressesProvider.getSIGHNFTBoosters());
        return true;
    }

// ############################################################################################################################
// ###### EXTERNAL FUNCTIONS TO CALCULATE THE FEE #############################################################################################
// ###### 1. calculateDepositFee() ##########
// ###### 2. calculateFlashLoanFee() #######################################
// ###### 1. calculateBorrowFee() ##########
// ############################################################################################################################

    function calculateDepositFee(address _user,address instrument, uint256 _amount, uint boosterId) external override onlyLendingPool returns (uint256 ,uint256 ,uint256 ) {

        uint totalFee = _amount.percentMul(totalDepositFeePercent);       // totalDepositFeePercent = 50 represents 0.5%
        uint platformFee = totalFee.percentMul(platformFeePercent);       // platformFeePercent = 5000 represents 50%
        uint sighPay = totalFee.sub(platformFee);

        if (boosterId == 0) {
            return (totalFee,platformFee,sighPay);
        }

        require( _user == SIGH_Boosters.ownerOfBooster(boosterId), "Deposit() caller doesn't have the mentioned SIGH Booster needed to claim the discount. Please check the BoosterID that you provided again." );

        if ( !boosterFuelInfo[boosterId].initiated ) {
            string memory category = SIGH_Boosters.getBoosterCategory(boosterId);
            boosterFuelInfo[boosterId].totalFuelRemaining = initialFuelAmount[category];
            boosterFuelInfo[boosterId].initiated = true;
        }

        if ( boosterFuelInfo[boosterId].totalFuelRemaining > 0 ) {
            uint priceUSD = priceOracle.getAssetPrice(instrument);
            uint priceDecimals = priceOracle.getAssetPriceDecimals(instrument);
            require(priceUSD > 0, "Oracle returned invalid price");

            uint value = totalFee.mul(priceUSD * 10**8);              // Adjusted by 8 decimals
            value = value.div(10**priceDecimals);                     // Corrected by Price Decimals

            boosterFuelInfo[boosterId].totalFuelRemaining = boosterFuelInfo[boosterId].totalFuelRemaining >= value ? boosterFuelInfo[boosterId].totalFuelRemaining.sub(value) : 0 ;
            boosterFuelInfo[boosterId].totalFuelUsed = boosterFuelInfo[boosterId].totalFuelUsed.add(value);
            return (0,0,0);
        }

        (uint platformFeeDiscount, uint sighPayDiscount) = SIGH_Boosters.getDiscountRatiosForBooster(boosterId);
        platformFee = platformFee.sub( platformFee.div(platformFeeDiscount) ) ;
        sighPay = sighPay.sub( sighPay.div(sighPayDiscount) ) ;
        totalFee = platformFee.add(sighPay);

        return (totalFee, platformFee,sighPay) ;
    }


    function calculateFlashLoanFee(address _user, uint256 _amount, uint boosterId) external view override returns (uint256 ,uint256 ,uint256) {
        uint totalFee = _amount.percentMul(totalFlashLoanFeePercent);       // totalFlashLoanFeePercent = 5 represents 0.05%
        uint platformFee = totalFee.percentMul(platformFeePercent);       // platformFeePercent = 5000 represents 50%
        uint sighPay = totalFee.sub(platformFee);

        if (boosterId == 0) {
            return (totalFee,platformFee,sighPay);
        }

        require( _user == SIGH_Boosters.ownerOfBooster(boosterId), "FlashLoan() caller doesn't have the mentioned SIGH Booster needed to claim the discount on Fee. Please check the BoosterID that you provided again." );

        (uint platformFeeDiscount, uint sighPayDiscount) = SIGH_Boosters.getDiscountRatiosForBooster(boosterId);
        platformFee = platformFee.sub( platformFee.div(platformFeeDiscount) ) ;
        sighPay = sighPay.sub( sighPay.div(sighPayDiscount) ) ;
        totalFee = platformFee.add(sighPay);
        
        return (totalFee,platformFee,sighPay);
    }
    
    

    function calculateBorrowFee(address _user, address instrument, uint256 _amount, uint boosterId) external override onlyLendingPool returns (uint256, uint256) {
        uint totalFee = _amount.percentMul(totalBorrowFeePercent);       // totalDepositFeePercent = 50 represents 0.5%
        uint256 platformFee = totalFee.percentMul(platformFeePercent);       // platformFeePercent = 5000 represents 50%
        uint256 reserveFee = totalFee.sub(platformFee);

        if (boosterId == 0) {
            return (platformFee,reserveFee);
        }

        require( _user == SIGH_Boosters.ownerOfBooster(boosterId), "User against which borrow is being initiated doesn't have the mentioned SIGH Booster needed to claim the discount. Please check the BoosterID that you provided again." );

        if ( !boosterFuelInfo[boosterId].initiated ) {
            string memory category = SIGH_Boosters.getBoosterCategory(boosterId);
            boosterFuelInfo[boosterId].totalFuelRemaining = initialFuelAmount[category];
            boosterFuelInfo[boosterId].initiated = true;
        }

        if (  boosterFuelInfo[boosterId].totalFuelRemaining > 0 ) {
            uint priceUSD = priceOracle.getAssetPrice(instrument);
            uint priceDecimals = priceOracle.getAssetPriceDecimals(instrument);
            require(priceUSD > 0, "Oracle returned invalid price");

            uint value = totalFee.mul(priceUSD * 10**8);              // Adjusted by 8 decimals
            value = value.div(10**priceDecimals);                     // Corrected by Price Decimals

            boosterFuelInfo[boosterId].totalFuelRemaining =  boosterFuelInfo[boosterId].totalFuelRemaining >= value ?  boosterFuelInfo[boosterId].totalFuelRemaining.sub(value) : 0 ;
            boosterFuelInfo[boosterId].totalFuelUsed = boosterFuelInfo[boosterId].totalFuelUsed.add(value);
            return (0,0);
        }

        (uint platformFeeDiscount, uint reserveFeeDiscount) = SIGH_Boosters.getDiscountRatiosForBooster(boosterId);
        platformFee = platformFee.sub( platformFee.div(platformFeeDiscount) ) ;
        reserveFee = reserveFee.sub( reserveFee.div(reserveFeeDiscount) ) ;

        return (platformFee,reserveFee) ;
    }

// #################################
// ####### FUNCTIONS TO INCREASE FUEL LIMIT  ########
// #################################

    function fuelTopUp(uint optionNo, uint boosterID) override external {
        require( SIGH_Boosters.isValidBooster(boosterID) , "Not a Valid Booster" );
        string memory category = SIGH_Boosters.getBoosterCategory(boosterID);

        optionType memory selectedOption = fuelTopUpOptions[category][optionNo];
        uint amount = selectedOption.fee;
        require(amount > 0,"Option selected not valid");

        uint8 decimals = IERC20Detailed(tokenAccepted).decimals();
        amount = amount.mul(10**decimals);

        uint256 prevBalance = IERC20(tokenAccepted).balanceOf(address(this));
        IERC20(tokenAccepted).transferFrom(msg.sender,address(this),amount);
        uint256 newBalance = IERC20(tokenAccepted).balanceOf(address(this));
        require( newBalance == prevBalance.add(amount),"ERC20 transfer failure");

        uint _multiplier = selectedOption.multiplier;
        uint topUp = amount.mul(_multiplier);
        topUp = topUp.div(100);                    // topUp = fee * multiplier, where multipler = 120 represents 1.2
        
        boosterFuelInfo[boosterID].totalFuelRemaining = boosterFuelInfo[boosterID].totalFuelRemaining.add(topUp);
        emit _boosterTopUp( boosterID, optionNo, amount, topUp, boosterFuelInfo[boosterID].totalFuelRemaining);
    }



// #################################
// ####### ADMIN FUNCTIONS  ########
// #################################

    function updateTotalDepositFeePercent(uint _depositFeePercent) external override onlySighFinanceConfigurator returns (bool) {
        totalDepositFeePercent = _depositFeePercent;
        emit depositFeePercentUpdated(_depositFeePercent);
        return true;
    }

    function updateTotalBorrowFeePercent(uint totalBorrowFeePercent_) external override onlySighFinanceConfigurator returns (bool) {
        totalBorrowFeePercent = totalBorrowFeePercent_;
        emit borrowFeePercentUpdated(totalBorrowFeePercent_);
        return true;
    }

    function updateTotalFlashLoanFeePercent(uint totalFlashLoanFeePercent_ ) external override onlySighFinanceConfigurator returns (bool) {
        totalFlashLoanFeePercent = totalFlashLoanFeePercent_;
        emit flashLoanFeePercentUpdated(totalFlashLoanFeePercent_);
        return true;
    }

    function updatePlatformFeePercent(uint _platformFeePercent) external override onlySighFinanceConfigurator returns (bool) {
        platformFeePercent = _platformFeePercent;
        emit platformFeePercentUpdated(_platformFeePercent);
        return true;
    }

    function UpdateABoosterCategoryFuelAmount(string memory categoryName, uint initialFuel ) external override onlySighFinanceConfigurator returns (bool) {
        require(initialFuel > 0, 'Initial Fuel cannot be 0'); 
        require(SIGH_Boosters.isCategorySupported(categoryName),'Category not present');
        initialFuelAmount[categoryName] = initialFuel;

        emit initalFuelForABoosterCategoryUpdated(categoryName,initialFuel);
        return true;
    }

    function updateATopUpOption(string memory category, uint optionNo, uint _fee, uint _multiplier) external override onlySighFinanceConfigurator returns (bool) {
        optionType memory newType = optionType({ fee: _fee, multiplier: _multiplier  });
        fuelTopUpOptions[category][optionNo] = newType;
        emit topUpOptionUpdated(category, optionNo, _fee, _multiplier);
        return true;
    }

    function updateTokenAccepted(address _token) external override onlySighFinanceConfigurator returns (bool) {
        require(_token != address(0),'Not a valid address');
        address prevToken = tokenAccepted;
        tokenAccepted = _token;
        emit tokenForPaymentUpdated(prevToken, tokenAccepted);
        return true;
    }

    function transferFunds(address token, address destination, uint amount) external override onlySighFinanceConfigurator returns (bool) {
        require(token != address(0),'Not a valid token address');
        require(destination != address(0),'Not a valid  destination address');
        require(amount > 0,'Amount needs to be greater than 0');

        uint256 prevBalance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(destination,amount);
        uint256 newBalance = IERC20(token).balanceOf(address(this));
        require( newBalance == prevBalance.sub(amount),"ERC20 transfer failure");

        emit tokensTransferred(token, destination, amount, newBalance );
        return true;
    }

// ###############################
// ####### EXTERNAL VIEW  ########
// ###############################

    function getBorrowFeePercentage() external view override returns (uint256) {
        return totalBorrowFeePercent;
    }

    function getDepositFeePercentage() external view override returns (uint256) {
        return totalDepositFeePercent;
    }

    function getFlashLoanFeePercentage() external view override returns (uint256) {
        return totalFlashLoanFeePercent;
    }

    function getFuelAvailable(uint boosterID) external view override returns (uint256) {
        return boosterFuelInfo[boosterID].totalFuelRemaining;
    }

    function getFuelUsed(uint boosterID) external view override returns (uint256) {
        return  boosterFuelInfo[boosterID].totalFuelUsed;
    }

    function getOptionDetails(string memory category, uint optionNo) external view override returns (uint fee, uint multiplier) {
        return (fuelTopUpOptions[category][optionNo].fee, fuelTopUpOptions[category][optionNo].multiplier);
    }

}
