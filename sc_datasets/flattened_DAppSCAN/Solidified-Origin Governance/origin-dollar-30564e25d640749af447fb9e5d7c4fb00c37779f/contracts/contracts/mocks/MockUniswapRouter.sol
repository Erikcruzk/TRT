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

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/interfaces/uniswap/IUniswapV2Router02.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IUniswapV2Router {
    function WETH() external pure returns (address);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/interfaces/IBasicToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IBasicToken {
    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/utils/Helpers.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

library Helpers {
    /**
     * @notice Fetch the `symbol()` from an ERC20 token
     * @dev Grabs the `symbol()` from a contract
     * @param _token Address of the ERC20 token
     * @return string Symbol of the ERC20 token
     */
    function getSymbol(address _token) internal view returns (string memory) {
        string memory symbol = IBasicToken(_token).symbol();
        return symbol;
    }

    /**
     * @notice Fetch the `decimals()` from an ERC20 token
     * @dev Grabs the `decimals()` from a contract and fails if
     *      the decimal value does not live within a certain range
     * @param _token Address of the ERC20 token
     * @return uint256 Decimals of the ERC20 token
     */
    function getDecimals(address _token) internal view returns (uint256) {
        uint256 decimals = IBasicToken(_token).decimals();
        require(
            decimals >= 4 && decimals <= 18,
            "Token must have sufficient decimal places"
        );

        return decimals;
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
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
        return a + b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
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
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/utils/StableMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

// Based on StableMath from Stability Labs Pty. Ltd.
// https://github.com/mstable/mStable-contracts/blob/master/contracts/shared/StableMath.sol

library StableMath {
    using SafeMath for uint256;

    /**
     * @dev Scaling unit for use in specific calculations,
     * where 1 * 10**18, or 1e18 represents a unit '1'
     */
    uint256 private constant FULL_SCALE = 1e18;

    /***************************************
                    Helpers
    ****************************************/

    /**
     * @dev Adjust the scale of an integer
     * @param to Decimals to scale to
     * @param from Decimals to scale from
     */
    function scaleBy(
        uint256 x,
        uint256 to,
        uint256 from
    ) internal pure returns (uint256) {
        if (to > from) {
            x = x.mul(10**(to - from));
        } else if (to < from) {
            x = x.div(10**(from - to));
        }
        return x;
    }

    /***************************************
               Precise Arithmetic
    ****************************************/

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale
     * @param x Left hand input to multiplication
     * @param y Right hand input to multiplication
     * @return Result after multiplying the two inputs and then dividing by the shared
     *         scale unit
     */
    function mulTruncate(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the given scale. For example,
     * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
     * @param x Left hand input to multiplication
     * @param y Right hand input to multiplication
     * @param scale Scale unit
     * @return Result after multiplying the two inputs and then dividing by the shared
     *         scale unit
     */
    function mulTruncateScale(
        uint256 x,
        uint256 y,
        uint256 scale
    ) internal pure returns (uint256) {
        // e.g. assume scale = fullScale
        // z = 10e18 * 9e17 = 9e36
        uint256 z = x.mul(y);
        // return 9e36 / 1e18 = 9e18
        return z.div(scale);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
     * @param x Left hand input to multiplication
     * @param y Right hand input to multiplication
     * @return Result after multiplying the two inputs and then dividing by the shared
     *          scale unit, rounded up to the closest base unit.
     */
    function mulTruncateCeil(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e17 * 17268172638 = 138145381104e17
        uint256 scaled = x.mul(y);
        // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
        uint256 ceil = scaled.add(FULL_SCALE.sub(1));
        // e.g. 13814538111.399...e18 / 1e18 = 13814538111
        return ceil.div(FULL_SCALE);
    }

    /**
     * @dev Precisely divides two units, by first scaling the left hand operand. Useful
     *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
     * @param x Left hand input to division
     * @param y Right hand input to division
     * @return Result after multiplying the left operand by the scale, and
     *         executing the division on the right hand input.
     */
    function divPrecisely(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e18 * 1e18 = 8e36
        uint256 z = x.mul(FULL_SCALE);
        // e.g. 8e36 / 10e18 = 8e17
        return z.div(y);
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/mocks/MockUniswapRouter.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;



contract MockUniswapRouter is IUniswapV2Router {
    using StableMath for uint256;

    mapping(address => address) public pairMaps;

    function initialize(
        address[] calldata _0tokens,
        address[] calldata _1tokens
    ) public {
        require(
            _0tokens.length == _1tokens.length,
            "Mock token pairs should be of the same length"
        );
        for (uint256 i = 0; i < _0tokens.length; i++) {
            pairMaps[_0tokens[i]] = _1tokens[i];
        }
    }

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external override returns (uint256[] memory amounts) {
        address tok0 = path[0];
        address tok1 = pairMaps[tok0];
        // Give 1:1
        uint256 amountOut = amountIn.scaleBy(
            Helpers.getDecimals(tok1),
            Helpers.getDecimals(tok0)
        );
        require(amountOut >= amountOutMin, "Slippage error");

        IERC20(tok0).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tok1).transfer(to, amountOut);
    }

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    function exactInput(ExactInputParams calldata params)
        external
        payable
        returns (uint256 amountOut)
    {
        bytes memory tok0Bytes = new bytes(20);
        for (uint256 i = 0; i < 20; i++) {
            tok0Bytes[i] = params.path[i];
        }

        address tok0 = address(bytes20(tok0Bytes));
        address tok1 = pairMaps[tok0];

        amountOut = params.amountIn.scaleBy(
            Helpers.getDecimals(tok1),
            Helpers.getDecimals(tok0)
        );
        IERC20(tok0).transferFrom(msg.sender, address(this), params.amountIn);
        IERC20(tok1).transfer(params.recipient, amountOut);
        require(
            amountOut >= params.amountOutMinimum,
            "UniswapMock: amountOut less than amountOutMinimum"
        );
        return amountOut;
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        override
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        )
    {
        // this is needed to make this contract whole else it'd be just virtual
    }

    function WETH() external pure override returns (address) {
        return address(0);
    }
}
