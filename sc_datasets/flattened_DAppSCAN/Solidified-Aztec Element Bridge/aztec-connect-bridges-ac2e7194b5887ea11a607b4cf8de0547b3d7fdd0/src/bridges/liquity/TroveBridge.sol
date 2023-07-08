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

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;



/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
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
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
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
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
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
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
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
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
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

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
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
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

// File: @openzeppelin/contracts/access/Ownable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/math/Math.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Down, // Toward negative infinity
        Up, // Toward infinity
        Zero // Toward zero
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
     * with further edits by Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod0 := mul(x, y)
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            require(denominator > prod1, "Math: mulDiv overflow");

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
            // See https://cs.stackexchange.com/q/138556/92363.

            // Does not overflow because the denominator cannot be zero at this stage in the function.
            uint256 twos = denominator & (~denominator + 1);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
            // in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10, rounded down, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256, rounded down, of a positive value.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
        }
    }
}

// File: @openzeppelin/contracts/utils/math/SignedMath.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two signed numbers.
     */
    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            // must be unchecked in order to support `n = type(int256).min`
            return uint256(n >= 0 ? n : -n);
        }
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)

pragma solidity ^0.8.0;


/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toString(int256 value) internal pure returns (string memory) {
        return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/aztec/AztecTypes.sol

// SPDX-License-Identifier: GPL-2.0-only
// Copyright 2020 Spilsbury Holdings Ltd

pragma solidity >=0.6.10 <=0.8.10;
pragma experimental ABIEncoderV2;

library AztecTypes {
  enum AztecAssetType {
    NOT_USED,
    ETH,
    ERC20,
    VIRTUAL
  }

  struct AztecAsset {
    uint256 id;
    address erc20Address;
    AztecAssetType assetType;
  }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/interfaces/IDefiBridge.sol

// SPDX-License-Identifier: GPL-2.0-only
// Copyright 2020 Spilsbury Holdings Ltd
pragma solidity >=0.6.6 <0.8.11;
pragma experimental ABIEncoderV2;

interface IDefiBridge {
  /**
   * Input cases:
   * Case1: 1 real input.
   * Case2: 1 virtual asset input.
   * Case3: 1 real 1 virtual input.
   *
   * Output cases:
   * Case1: 1 real
   * Case2: 2 real
   * Case3: 1 real 1 virtual
   * Case4: 1 virtual
   *
   * Example use cases with asset mappings
   * 1 1: Swapping.
   * 1 2: Swapping with incentives (2nd output reward token).
   * 1 3: Borrowing. Lock up collateral, get back loan asset and virtual position asset.
   * 1 4: Opening lending position OR Purchasing NFT. Input real asset, get back virtual asset representing NFT or position.
   * 2 1: Selling NFT. Input the virtual asset, get back a real asset.
   * 2 2: Closing a lending position. Get back original asset and reward asset.
   * 2 3: Claiming fees from an open position.
   * 2 4: Voting on a 1 4 case.
   * 3 1: Repaying a borrow. Return loan plus interest. Get collateral back.
   * 3 2: Repaying a borrow. Return loan plus interest. Get collateral plus reward token. (AAVE)
   * 3 3: Partial loan repayment.
   * 3 4: DAO voting stuff.
   */

  // @dev This function is called from the RollupProcessor.sol contract via the DefiBridgeProxy. It receives the aggreagte sum of all users funds for the input assets.
  // @param AztecAsset inputAssetA a struct detailing the first input asset, this will always be set
  // @param AztecAsset inputAssetB an optional struct detailing the second input asset, this is used for repaying borrows and should be virtual
  // @param AztecAsset outputAssetA a struct detailing the first output asset, this will always be set
  // @param AztecAsset outputAssetB a struct detailing an optional second output asset
  // @param uint256 inputValue, the total amount input, if there are two input assets, equal amounts of both assets will have been input
  // @param uint256 interactionNonce a globally unique identifier for this DeFi interaction. This is used as the assetId if one of the output assets is virtual
  // @param uint64 auxData other data to be passed into the bridge contract (slippage / nftID etc)
  // @return uint256 outputValueA the amount of outputAssetA returned from this interaction, should be 0 if async
  // @return uint256 outputValueB the amount of outputAssetB returned from this interaction, should be 0 if async or bridge only returns 1 asset.
  // @return bool isAsync a flag to toggle if this bridge interaction will return assets at a later date after some third party contract has interacted with it via finalise()
  function convert(
    AztecTypes.AztecAsset calldata inputAssetA,
    AztecTypes.AztecAsset calldata inputAssetB,
    AztecTypes.AztecAsset calldata outputAssetA,
    AztecTypes.AztecAsset calldata outputAssetB,
    uint256 inputValue,
    uint256 interactionNonce,
    uint64 auxData,
    address rollupBeneficiary
  )
    external
    payable
    virtual
    returns (
      uint256 outputValueA,
      uint256 outputValueB,
      bool isAsync
    );

  // @dev This function is called from the RollupProcessor.sol contract via the DefiBridgeProxy. It receives the aggreagte sum of all users funds for the input assets.
  // @param AztecAsset inputAssetA a struct detailing the first input asset, this will always be set
  // @param AztecAsset inputAssetB an optional struct detailing the second input asset, this is used for repaying borrows and should be virtual
  // @param AztecAsset outputAssetA a struct detailing the first output asset, this will always be set
  // @param AztecAsset outputAssetB a struct detailing an optional second output asset
  // @param uint256 interactionNonce
  // @param uint64 auxData other data to be passed into the bridge contract (slippage / nftID etc)
  // @return uint256 outputValueA the return value of output asset A
  // @return uint256 outputValueB optional return value of output asset B
  // @dev this function should have a modifier on it to ensure it can only be called by the Rollup Contract
  function finalise(
    AztecTypes.AztecAsset calldata inputAssetA,
    AztecTypes.AztecAsset calldata inputAssetB,
    AztecTypes.AztecAsset calldata outputAssetA,
    AztecTypes.AztecAsset calldata outputAssetB,
    uint256 interactionNonce,
    uint64 auxData
  ) external payable virtual returns (uint256 outputValueA, uint256 outputValueB, bool interactionComplete);


}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/interfaces/IRollupProcessor.sol

// SPDX-License-Identifier: Apache-2.0
// Copyright 2022 Aztec
pragma solidity >=0.8.4 <0.8.11;

interface IRollupProcessor {
    function defiBridgeProxy() external view returns (address);

    function processRollup(
        bytes calldata proofData,
        bytes calldata signatures,
        bytes calldata offchainTxData
    ) external;

    function depositPendingFunds(
        uint256 assetId,
        uint256 amount,
        address owner,
        bytes32 proofHash
    ) external payable;

    function depositPendingFundsPermit(
        uint256 assetId,
        uint256 amount,
        address owner,
        bytes32 proofHash,
        address spender,
        uint256 permitApprovalAmount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function receiveEthFromBridge(uint256 interactionNonce) external payable;

    function setRollupProvider(address provderAddress, bool valid) external;

    function approveProof(bytes32 _proofHash) external;

    function pause() external;

    function setDefiBridgeProxy(address feeDistributorAddress) external;

    function setVerifier(address verifierAddress) external;

    function setSupportedAsset(
        address linkedToken,
        bool supportsPermit,
        uint256 gasLimit
    ) external;

    function setAssetPermitSupport(uint256 assetId, bool supportsPermit) external;

    function setSupportedBridge(address linkedBridge, uint256 gasLimit) external;

    function getSupportedAsset(uint256 assetId) external view returns (address);

    function getSupportedAssets() external view returns (address[] memory);

    function getSupportedBridge(uint256 bridgeAddressId) external view returns (address);

    function getBridgeGasLimit(uint256 bridgeAddressId) external view returns (uint256);

    function getSupportedBridges() external view returns (address[] memory);

    function getAssetPermitSupport(uint256 assetId) external view returns (bool);

    function getEscapeHatchStatus() external view returns (bool, uint256);

    function getUserPendingDeposit(uint256 assetId, address userAddress) external view returns (uint256);

    function processAsyncDefiInteraction(uint256 interactionNonce) external returns (bool);

    event DefiBridgeProcessed(
        uint256 indexed bridgeId,
        uint256 indexed nonce,
        uint256 totalInputValue,
        uint256 totalOutputValueA,
        uint256 totalOutputValueB,
        bool result
    );
    event AsyncDefiBridgeProcessed(
        uint256 indexed bridgeId,
        uint256 indexed nonce,
        uint256 totalInputValue,
        uint256 totalOutputValueA,
        uint256 totalOutputValueB,
        bool result
    );
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/IBorrowerOperations.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IBorrowerOperations {
    function openTrove(uint _maxFee, uint _LUSDAmount, address _upperHint, address _lowerHint) external payable;

    function closeTrove() external;

    function adjustTrove(uint _maxFee, uint _collWithdrawal, uint _debtChange, bool isDebtIncrease, address _upperHint, address _lowerHint) external payable;

    function claimCollateral() external;
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/IPriceFeed.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IPriceFeed {
    function fetchPrice() external returns (uint);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/ILiquityBase.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface ILiquityBase {
    function priceFeed() external view returns (IPriceFeed);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/IStabilityPool.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface IStabilityPool {
    function provideToSP(uint256 _amount, address _frontEndTag) external;

    function withdrawFromSP(uint256 _amount) external;

    function getCompoundedLUSDDeposit(address _depositor) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/ILQTYStaking.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface ILQTYStaking {
    function stakes(address _user) external view returns (uint);

    function stake(uint _LQTYamount) external;

    function unstake(uint _LQTYamount) external;
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/ITroveManager.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;



// Common interface for the Trove Manager.
interface ITroveManager is ILiquityBase {
    function getCurrentICR(address _borrower, uint _price) external view returns (uint);

    function liquidate(address _borrower) external;

    function redeemCollateral(
        uint _LUSDAmount,
        address _firstRedemptionHint,
        address _upperPartialRedemptionHint,
        address _lowerPartialRedemptionHint,
        uint _partialRedemptionHintNICR,
        uint _maxIterations,
        uint _maxFee
    ) external;

    function getEntireDebtAndColl(address _borrower) external view returns (
        uint debt, 
        uint coll, 
        uint pendingLUSDDebtReward, 
        uint pendingETHReward
    );

    function closeTrove(address _borrower) external;

    function getBorrowingRateWithDecay() external view returns (uint);

    function getTroveStatus(address _borrower) external view returns (uint);
    
    function checkRecoveryMode(uint _price) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/interfaces/ISortedTroves.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.10;

interface ISortedTroves {
    function getNext(address _id) external view returns (address);

    function getPrev(address _id) external view returns (address);

    function findInsertPosition(uint256 _ICR, address _prevId, address _nextId) external view returns (address, address);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Element Bridge/aztec-connect-bridges-ac2e7194b5887ea11a607b4cf8de0547b3d7fdd0/src/bridges/liquity/TroveBridge.sol

// SPDX-License-Identifier: GPL-2.0-only
// Copyright 2022 Spilsbury Holdings Ltd
pragma solidity >=0.8.0 <=0.8.10;
pragma abicoder v2;








/**
 * @title Aztec Connect Bridge for opening and closing Liquity's troves
 * @author Jan Benes (@benesjan on Github and Telegram)
 * @notice You can use this contract to borrow and repay LUSD
 * @dev The contract inherits from OpenZeppelin's implementation of ERC20 token because token balances are used to track
 * the depositor's ownership of the assets controlled by the bridge contract. The token is called TroveBridge and
 * the token symbol is TB-[initial ICR] (ICR is an acronym for individual collateral ratio). 1 TB token always
 * represents 1 LUSD worth of debt. In case the trove is not closed by redemption or liquidation, users can withdraw
 * their collateral by supplying TB and an equal amount of LUSD to the bridge. 1 deployment of the bridge contract
 * controls 1 trove. The bridge keeps precise accounting of debt by making sure that no user can change the trove's ICR.
 * This means that when a price goes down the only way how a user can avoid liquidation penalty is to repay their debt.
 *
 * In case the trove gets liquidated, the bridge no longer controls any ETH and all the TB balances are irrelevant.
 * At this point the bridge is defunct unless owner is the only one who borrowed. If owner is the only who borrowed
 * calling closeTrove() will succeed and owner's balance will get burned making TB total supply 0.
 *
 * If the trove is closed by redemption, users can withdraw their remaining collateral by supplying their TB.
 */
contract TroveBridge is ERC20, Ownable, IDefiBridge {
    using Strings for uint256;

    address public constant LUSD = 0x5f98805A4E8be255a32880FDeC7F6728C6568bA0;

    IBorrowerOperations public constant operations = IBorrowerOperations(0x24179CD81c9e782A4096035f7eC97fB8B783e007);
    ITroveManager public constant troveManager = ITroveManager(0xA39739EF8b0231DbFA0DcdA07d7e29faAbCf4bb2);
    ISortedTroves public constant sortedTroves = ISortedTroves(0x8FdD3fbFEb32b28fb73555518f8b361bCeA741A6);

    address public immutable processor;
    uint256 public immutable initialICR;
    uint256 public immutable maxFee;

    // Used to check whether collateral has already been claimed during redemptions.
    bool private _collateralClaimed;

    // Trove status taken from TroveManager.sol
    enum Status {
        nonExistent,
        active,
        closedByOwner,
        closedByLiquidation,
        closedByRedemption
    }

    /**
     * @notice Set the address of RollupProcessor.sol and initial ICR
     * @param _processor Address of the RollupProcessor.sol
     * @param _initialICRPerc Collateral ratio denominated in percents to be used when opening the Trove
     */
    constructor(
        address _processor,
        uint256 _initialICRPerc,
        uint256 _maxFee
    ) ERC20("TroveBridge", string(abi.encodePacked("TB-", _initialICRPerc.toString()))) {
        processor = _processor;
        initialICR = _initialICRPerc * 1e16;
        maxFee = _maxFee;
    }

    /**
     * @notice A function which opens the trove.
     * @param _upperHint Address of a Trove with a position in the sorted list before the correct insert position.
     * @param _lowerHint Address of a Trove with a position in the sorted list after the correct insert position.
     * See https://github.com/liquity/dev#supplying-hints-to-trove-operations for more details about hints.
     * @dev Sufficient amount of ETH has to be send so that at least 2000 LUSD gets borrowed. 2000 LUSD is a minimum
     * amount allowed by Liquity.
     */
    function openTrove(address _upperHint, address _lowerHint) external payable onlyOwner {
        // Checks whether the trove can be safely opened/reopened
        require(this.totalSupply() == 0, "TroveBridge: INCORRECT_TOTAL_SUPPLY");

        require(IERC20(LUSD).approve(processor, type(uint256).max), "TroveBridge: LUSD_APPROVE_FAILED");
        require(this.approve(processor, type(uint256).max), "TroveBridge: TB_APPROVE_FAILED");

        uint256 amtToBorrow = computeAmtToBorrow(msg.value);

        (uint256 debtBefore, , , ) = troveManager.getEntireDebtAndColl(address(this));
        operations.openTrove{value: msg.value}(maxFee, amtToBorrow, _upperHint, _lowerHint);
        (uint256 debtAfter, , , ) = troveManager.getEntireDebtAndColl(address(this));

        IERC20(LUSD).transfer(msg.sender, IERC20(LUSD).balanceOf(address(this)));
        // I mint TB token to msg.sender to be able to track collateral ownership. Minted amount equals debt increase.
        _mint(msg.sender, debtAfter - debtBefore);
    }

    /**
     * @notice A function which stakes or unstakes LQTY to/from LQTYStaking.sol.
     * @dev This method can only be called from the RollupProcessor.sol. If the input asset is ETH, borrowing flow is
     * executed. If TB, repaying. RollupProcessor.sol has to transfer the tokens to the bridge before calling
     * the method. If this is not the case, the function will revert.
     *
     *                              Borrowing               Repaying                Redeeming
     * @param inputAssetA -         ETH                     TB                      TB
     * @param inputAssetB -         None                    LUSD                    None
     * @param outputAssetA -        TB                      ETH                     ETH
     * @param outputAssetB -        LUSD                    None                    None
     * @param inputValue -          amount of ETH           amount of TB and LUSD   amount of TB
     * @return outputValueA -       amount of TB            amount of ETH           amount of ETH
     * @return outputValueB -       amount of LUSD          0                       0
     */
    function convert(
        AztecTypes.AztecAsset calldata inputAssetA,
        AztecTypes.AztecAsset calldata inputAssetB,
        AztecTypes.AztecAsset calldata outputAssetA,
        AztecTypes.AztecAsset calldata outputAssetB,
        uint256 inputValue,
        uint256 interactionNonce,
        uint64,
        address

    )
        external
        payable
        returns (
            uint256 outputValueA,
            uint256 outputValueB,
            bool isAsync
        )
    {
        require(msg.sender == processor, "TroveBridge: INVALID_CALLER");
        Status troveStatus = Status(troveManager.getTroveStatus(address(this)));

        address upperHint = sortedTroves.getPrev(address(this));
        address lowerHint = sortedTroves.getNext(address(this));

        if (
            inputAssetA.assetType == AztecTypes.AztecAssetType.ETH &&
            outputAssetA.erc20Address == address(this) &&
            outputAssetB.erc20Address == LUSD
        ) {
            // Borrowing
            require(troveStatus == Status.active, "TroveBridge: INACTIVE_TROVE");
            // outputValueA = by how much debt will increase and how much TB to mint
            outputValueB = computeAmtToBorrow(inputValue); // LUSD amount to borrow

            (uint256 debtBefore, , , ) = troveManager.getEntireDebtAndColl(address(this));
            operations.adjustTrove{value: inputValue}(maxFee, 0, outputValueB, true, upperHint, lowerHint);
            (uint256 debtAfter, , , ) = troveManager.getEntireDebtAndColl(address(this));

            // outputValueA = debt increase = amount of TB to mint
            outputValueA = debtAfter - debtBefore;
            _mint(address(this), outputValueA);
        } else if (
            inputAssetA.erc20Address == address(this) &&
            inputAssetB.erc20Address == LUSD &&
            outputAssetA.assetType == AztecTypes.AztecAssetType.ETH
        ) {
            // Repaying
            require(troveStatus == Status.active, "TroveBridge: INACTIVE_TROVE");
            (, uint256 coll, , ) = troveManager.getEntireDebtAndColl(address(this));
            outputValueA = (coll * inputValue) / this.totalSupply(); // Amount of collateral to withdraw
            operations.adjustTrove(maxFee, outputValueA, inputValue, false, upperHint, lowerHint);
            _burn(address(this), inputValue);
            IRollupProcessor(processor).receiveEthFromBridge{value: outputValueA}(interactionNonce);
        } else if (
            inputAssetA.erc20Address == address(this) && outputAssetA.assetType == AztecTypes.AztecAssetType.ETH
        ) {
            // Redeeming
            require(troveStatus == Status.closedByRedemption, "TroveBridge: INCORRECT_STATUS");
            if (!_collateralClaimed) {
                operations.claimCollateral();
                _collateralClaimed = true;
            }
            outputValueA = (address(this).balance * inputValue) / this.totalSupply();
            _burn(address(this), inputValue);
            IRollupProcessor(processor).receiveEthFromBridge{value: outputValueA}(interactionNonce);
        } else {
            require(false, "TroveBridge: INCORRECT_INPUT");
        }
    }

    /**
     * @notice A function which closes the trove.
     * @dev LUSD allowance has to be at least (remaining debt - 200).
     */
    function closeTrove() public onlyOwner {
        address payable owner = payable(owner());
        uint256 ownerTBBalance = balanceOf(owner);
        require(ownerTBBalance == totalSupply(), "TroveBridge: OWNER_MUST_BE_LAST");

        _burn(owner, ownerTBBalance);

        Status troveStatus = Status(troveManager.getTroveStatus(address(this)));
        if (troveStatus == Status.active) {
            (uint256 remainingDebt, , , ) = troveManager.getEntireDebtAndColl(address(this));
            // 200e18 is a part of debt which gets repaid from LUSD_GAS_COMPENSATION.
            require(
                IERC20(LUSD).transferFrom(owner, address(this), remainingDebt - 200e18),
                "TroveBridge: LUSD_TRANSFER_FAILED"
            );
            operations.closeTrove();
        } else if (troveStatus == Status.closedByRedemption) {
            if (!_collateralClaimed) {
                operations.claimCollateral();
            } else {
                _collateralClaimed = false;
            }
        }

        owner.transfer(address(this).balance);
    }

    /**
     * @notice Compute how much LUSD to borrow against collateral in order to keep ICR constant and by how much total
     * trove debt will increase.
     * @param _coll Amount of ETH denominated in Wei
     * @return amtToBorrow Amount of LUSD to borrow to keep ICR constant.
     * + borrowing fee)
     * @dev I don't use view modifier here because the function updates PriceFeed state.
     *
     * Since the Trove opening and adjustment processes have desired amount of LUSD to borrow on the input and not
     * the desired ICR I have to do the computation of borrowing fee "backwards". Here are the operations I did in order
     * to get the final formula:
     *      1) debtIncrease = amtToBorrow + amtToBorrow * BORROWING_RATE / DECIMAL_PRECISION + 200LUSD
     *      2) debtIncrease - 200LUSD = amtToBorrow * (1 + BORROWING_RATE / DECIMAL_PRECISION)
     *      3) amtToBorrow = (debtIncrease - 200LUSD) / (1 + BORROWING_RATE / DECIMAL_PRECISION)
     *      4) amtToBorrow = (debtIncrease - 200LUSD) * DECIMAL_PRECISION / (DECIMAL_PRECISION + BORROWING_RATE)
     * Note1: For trove adjustments (not opening) remove the 200 LUSD fee compensation from the formulas above.
     * Note2: Step 4 is necessary to avoid loss of precision. BORROWING_RATE / DECIMAL_PRECISION was rounded to 0.
     * Note3: The borrowing fee computation is on this line in Liquity code: https://github.com/liquity/dev/blob/cb583ddf5e7de6010e196cfe706bd0ca816ea40e/packages/contracts/contracts/TroveManager.sol#L1433
     */
    function computeAmtToBorrow(uint256 _coll) public returns (uint256 amtToBorrow) {
        uint256 price = troveManager.priceFeed().fetchPrice();
        bool isRecoveryMode = troveManager.checkRecoveryMode(price);
        if (troveManager.getTroveStatus(address(this)) == 1) {
            // Trove is active - use current ICR and not the initial one
            uint256 icr = troveManager.getCurrentICR(address(this), price);
            amtToBorrow = (_coll * price) / icr;
            if (!isRecoveryMode) {
                // Liquity is not in recovery mode so borrowing fee applies
                uint256 borrowingRate = troveManager.getBorrowingRateWithDecay();
                amtToBorrow = (amtToBorrow * 1e18) / (borrowingRate + 1e18);
            }
        } else {
            // Trove is inactive - I will use initial ICR to compute debt
            // 200e18 - 200 LUSD gas compensation to liquidators
            amtToBorrow = (_coll * price) / initialICR - 200e18;
            if (!isRecoveryMode) {
                // Liquity is not in recovery mode so borrowing fee applies
                uint256 borrowingRate = troveManager.getBorrowingRateWithDecay();
                amtToBorrow = (amtToBorrow * 1e18) / (borrowingRate + 1e18);
            }
        }
    }

    // @notice This function always reverts because this contract does not implement async flow.
    function finalise(
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata,
        uint256,
        uint64
    )
        external
        payable
        returns (
            uint256,
            uint256,
            bool
        )
    {
        require(false, "TroveBridge: ASYNC_MODE_DISABLED");
    }

    receive() external payable {}

    fallback() external payable {}
}
