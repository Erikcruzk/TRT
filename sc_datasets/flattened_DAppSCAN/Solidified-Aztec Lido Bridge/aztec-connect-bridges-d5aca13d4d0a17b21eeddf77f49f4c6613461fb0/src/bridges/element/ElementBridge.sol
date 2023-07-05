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

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/interfaces/IERC20Permit.sol

// SPDX-License-Identifier: GPL-2.0-only
// Copyright 2020 Spilsbury Holdings Ltd
pragma solidity >=0.6.10 <=0.8.10;

interface IERC20Permit is IERC20 {
  function nonces(address user) external view returns (uint256);

  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/interfaces/IVault.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity <=0.8.10;
pragma abicoder v2;

interface IAsset {
    // solhint-disable-previous-line no-empty-blocks
}


enum PoolSpecialization { GENERAL, MINIMAL_SWAP_INFO, TWO_TOKEN }

interface IVault {
    enum SwapKind { GIVEN_IN, GIVEN_OUT }
/**
     * @dev Performs a swap with a single Pool.
     *
     * If the swap is 'given in' (the number of tokens to send to the Pool is known), it returns the amount of tokens
     * taken from the Pool, which must be greater than or equal to `limit`.
     *
     * If the swap is 'given out' (the number of tokens to take from the Pool is known), it returns the amount of tokens
     * sent to the Pool, which must be less than or equal to `limit`.
     *
     * Internal Balance usage and the recipient are determined by the `funds` struct.
     *
     * Emits a `Swap` event.
     */
    function swap(
        SingleSwap memory singleSwap,
        FundManagement memory funds,
        uint256 limit,
        uint256 deadline
    ) external payable returns (uint256);

    /**
     * @dev Data for a single swap executed by `swap`. `amount` is either `amountIn` or `amountOut` depending on
     * the `kind` value.
     *
     * `assetIn` and `assetOut` are either token addresses, or the IAsset sentinel value for ETH (the zero address).
     * Note that Pools never interact with ETH directly: it will be wrapped to or unwrapped from WETH by the Vault.
     *
     * The `userData` field is ignored by the Vault, but forwarded to the Pool in the `onSwap` hook, and may be
     * used to extend swap behavior.
     */
    struct SingleSwap {
        bytes32 poolId;
        SwapKind kind;
        IAsset assetIn;
        IAsset assetOut;
        uint256 amount;
        bytes userData;
    }

    /**
     * @dev All tokens in a swap are either sent from the `sender` account to the Vault, or from the Vault to the
     * `recipient` account.
     *
     * If the caller is not `sender`, it must be an authorized relayer for them.
     *
     * If `fromInternalBalance` is true, the `sender`'s Internal Balance will be preferred, performing an ERC20
     * transfer for the difference between the requested amount and the User's Internal Balance (if any). The `sender`
     * must have allowed the Vault to use their tokens via `IERC20.approve()`. This matches the behavior of
     * `joinPool`.
     *
     * If `toInternalBalance` is true, tokens will be deposited to `recipient`'s internal balance instead of
     * transferred. This matches the behavior of `exitPool`.
     *
     * Note that ETH cannot be deposited to or withdrawn from Internal Balance: attempting to do so will trigger a
     * revert.
     */
    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }

    // will revert if poolId is not a registered pool
    function getPool(bytes32 poolId) external view returns (address, PoolSpecialization);


    /**
     * @dev Simulates a call to `batchSwap`, returning an array of Vault asset deltas. Calls to `swap` cannot be
     * simulated directly, but an equivalent `batchSwap` call can and will yield the exact same result.
     *
     * Each element in the array corresponds to the asset at the same index, and indicates the number of tokens (or ETH)
     * the Vault would take from the sender (if positive) or send to the recipient (if negative). The arguments it
     * receives are the same that an equivalent `batchSwap` call would receive.
     *
     * Unlike `batchSwap`, this function performs no checks on the sender or recipient field in the `funds` struct.
     * This makes it suitable to be called by off-chain applications via eth_call without needing to hold tokens,
     * approve them for the Vault, or even know a user's address.
     *
     * Note that this function is not 'view' (due to implementation details): the client code must explicitly execute
     * eth_call instead of eth_sendTransaction.
     */

    struct BatchSwapStep {
        bytes32 poolId;
        uint256 assetInIndex;
        uint256 assetOutIndex;
        uint256 amount;
        bytes userData;
    }
    function queryBatchSwap(
        SwapKind kind,
        BatchSwapStep[] memory swaps,
        IAsset[] memory assets,
        FundManagement memory funds
    ) external view returns (int256[] memory assetDeltas);


    /**
     * @dev Returns a Pool's registered tokens, the total balance for each, and the latest block when *any* of
     * the tokens' `balances` changed.
     *
     * The order of the `tokens` array is the same order that will be used in `joinPool`, `exitPool`, as well as in all
     * Pool hooks (where applicable). Calls to `registerTokens` and `deregisterTokens` may change this order.
     *
     * If a Pool only registers tokens once, and these are sorted in ascending order, they will be stored in the same
     * order as passed to `registerTokens`.
     *
     * Total balances include both tokens held by the Vault and those withdrawn by the Pool's Asset Managers. These are
     * the amounts used by joins, exits and swaps. For a detailed breakdown of token balances, use `getPoolTokenInfo`
     * instead.
     */
    function getPoolTokens(bytes32 poolId)
        external
        view
        returns (
            IERC20[] memory tokens,
            uint256[] memory balances,
            uint256 lastChangeBlock
        );
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/interfaces/IPool.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.5;
pragma abicoder v2;


interface IPool is IERC20Permit {
  /// @dev Returns the poolId for this pool
  /// @return The poolId for this pool
  function getPoolId() external view returns (bytes32);

  function underlying() external view returns (IERC20);

  function expiration() external view returns (uint256);

  function getVault() external view returns (IVault);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/interfaces/ITranche.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.10 <=0.8.10;

interface ITranche is IERC20Permit {
  function deposit(uint256 _shares, address destination)
    external
    returns (uint256, uint256);

  function prefundedDeposit(address _destination)
    external
    returns (uint256, uint256);

  function withdrawPrincipal(uint256 _amount, address _destination)
    external
    returns (uint256);

  function withdrawInterest(uint256 _amount, address _destination)
    external
    returns (uint256);

  function interestSupply() external view returns (uint128);

  function position() external view returns (IERC20);

  function underlying() external view returns (IERC20);

  function speedbump() external view returns (uint256);

  function unlockTimestamp() external view returns (uint256);

  function hitSpeedbump() external;
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/interfaces/IDeploymentValidator.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IDeploymentValidator {
    function validateWPAddress(address wrappedPosition) external;

    function validatePoolAddress(address pool) external;

    function validateAddresses(address wrappedPosition, address pool) external;

    function checkWPValidation(address wrappedPosition)
        external
        view
        returns (bool);

    function checkPoolValidation(address pool) external view returns (bool);

    function checkPairValidation(address wrappedPosition, address pool)
        external
        view
        returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/interfaces/IERC20Permit.sol

// SPDX-License-Identifier: GPL-2.0-only
// Copyright 2020 Spilsbury Holdings Ltd
pragma solidity >=0.6.10 <=0.8.10;

interface IERC20Permit is IERC20 {
  function nonces(address user) external view returns (uint256);

  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/interfaces/IWrappedPosition.sol

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IWrappedPosition is IERC20Permit {
    function token() external view returns (IERC20);
    function vault() external view returns (address);

    function balanceOfUnderlying(address who) external view returns (uint256);

    function getSharesToUnderlying(uint256 shares)
        external
        view
        returns (uint256);

    function deposit(address sender, uint256 amount) external returns (uint256);

    function withdraw(
        address sender,
        uint256 _shares,
        uint256 _minUnderlying
    ) external returns (uint256);

    function withdrawUnderlying(
        address _destination,
        uint256 _amount,
        uint256 _minUnderlying
    ) external returns (uint256, uint256);

    function prefundedDeposit(address _destination)
        external
        returns (
            uint256,
            uint256,
            uint256
        );
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/interfaces/IRollupProcessor.sol

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

    function getDefiInteractionBlockNumber(uint256 interactionNonce) external view returns (uint256);

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

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/MinHeap.sol

pragma solidity 0.8.10;

/**
 * @title Min Heap
 * @dev Library for managing an array of uint64 values as a minimum heap
 */
library MinHeap {
    using MinHeap for MinHeapData;

    error HEAP_EMPTY();

    // maximum value of uint64. used as initial value in pre-allocated array 
    uint64 internal constant MAX_INT = 2**64 - 1;

    /**
     * @dev Encapsulates the underlyding data structure used to manage the heap
     *
     * @param heap the array of values contained within the heap
     * @param heapSize the current size of the heap, usually different to the size of underlying array so tracked seperately
     */
    struct MinHeapData {
        uint64[] heap;
        uint32 heapSize;
    }

    /**
     * @dev used to pre-allocate the underlying array with dummy values
     * Useful for gas optimisation later when tru value start to be added
     * @param self reference to the underlying data structure of the heap
     * @param initialSize the amount of slots to pre-allocate
     */
    function initialise(MinHeapData storage self, uint32 initialSize) internal {
        for (uint32 i = 0; i < initialSize; i++) {
            self.heap.push(MAX_INT);
        }
        self.heapSize = 0;
    }

    /**
     * @dev used to add a new value to the heap
     * @param self reference to the underlying data structure of the heap
     * @param value the value to add
     */
    function add(MinHeapData storage self, uint64 value) internal {
        addToHeap(self, value);
    }

    /**
     * @dev retrieve the current minimum value in the heap
     * @param self reference to the underlying data structure of the heap
     * @return minimum the heap's current minimum value
     */
    function min(MinHeapData storage self) internal view returns (uint64 minimum) {
        if (size(self) == 0) {
            revert HEAP_EMPTY();
        }
        minimum = self.heap[0];
    }

    /**
     * @dev used to remove a value from the heap
     * will remove the first found occurence of the value from the heap, optimised for removal of the minimum value
     * @param self reference to the underlying data structure of the heap
     * @param value the value to be removed
     */
    function remove(MinHeapData storage self, uint64 value) internal {
        removeExpiryFromHeap(self, value);
    }

    /**
     * @dev used to remove the minimum value from the heap
     * @param self reference to the underlying data structure of the heap
     */
    function pop(MinHeapData storage self) internal {
        popFromHeap(self);
    }

    /**
     * @dev retrieve the current size of the heap
     * @param self reference to the underlying data structure of the heap
     * @return currentSize the heap's current size
     */
    function size(MinHeapData storage self) internal view returns (uint256 currentSize) {
        currentSize = self.heapSize;
    }

    /**
     * @dev move the value at the given index up to the correct position in the heap
     * @param self reference to the underlying data structure of the heap
     * @param index the index of the element that is to be correctly positioned
     */
    function siftUp(MinHeapData storage self, uint256 index) internal {
        uint64 value = self.heap[index];
        while (index > 0) {
            uint256 parentIndex = (index - 1) / 2;
            if (self.heap[parentIndex] <= value) {
                break;
            }
            self.heap[index] = self.heap[parentIndex]; // update
            index = parentIndex;
        }
        self.heap[index] = value;
    }

    /**
     * @dev private implementation of adding to the heap
     * @param self reference to the underlying data structure of the heap
     * @param value the value to add
     */
    function addToHeap(MinHeapData storage self, uint64 value) private {
        // standard min-heap insertion
        // push to the end of the heap and sift up.
        // there is a high probability that the expiry being added will remain where it is
        // so this operation will end up being O(1)
        if (self.heapSize == self.heap.length) {
            self.heap.push(value);       
        } else {
            self.heap[self.heapSize] = value;
        }
        uint256 index = self.heapSize++;
        siftUp(self, index);
    }

    /**
     * @dev private implementation to remove the minimum value from the heap
     * @param self reference to the underlying data structure of the heap
     */
    function popFromHeap(MinHeapData storage self) private {
        // if the heap is empty then nothing to do
        if (self.heapSize == 0) {
            return;
        }
        // read the value in the last position and shrink the array by 1
        uint64 last = self.heap[--self.heapSize];
        // now sift down 
        // write the smallest child value into the parent each time
        // then once we no longer have any smaller children, we write the 'last' value into place
        // requires a total of O(logN) updates
        uint256 index = 0;
        while (index < self.heapSize) {
            // get the indices of the child values
            uint256 leftChildIndex = (index * 2) + 1;
            uint256 rightChildIndex = leftChildIndex + 1;
            uint256 swapIndex = index;
            uint64 smallestValue = last;

            // identify the smallest child, first check the left
            if (leftChildIndex < self.heapSize && self.heap[leftChildIndex] < smallestValue) {
                swapIndex = leftChildIndex;
                smallestValue = self.heap[leftChildIndex];
            }
            // then check the right
            if (rightChildIndex < self.heapSize && self.heap[rightChildIndex] < smallestValue) {
                swapIndex = rightChildIndex;
            }
            // if neither child was smaller then nothing more to do
            if (swapIndex == index) {
                self.heap[index] = smallestValue;
                break;
            }
            // take the value from the smallest child and write in into our slot
            self.heap[index] = self.heap[swapIndex];
            index = swapIndex;
        }
    }

    /**
     * @dev private implementation used to remove a value from the heap
     * will remove the first found occurence of the value from the heap, optimised for removal of the minimum value
     * @param self reference to the underlying data structure of the heap
     * @param value the value to be removed
     */
    function removeExpiryFromHeap(MinHeapData storage self, uint64 value) private {
        uint256 index = 0;
        while (index < self.heapSize && self.heap[index] != value) {
            ++index;
        }
        if (index == self.heapSize) {
            return;
        }
        if (index != 0) {
            // the value was found but it is not the minimum value
            // to remove this we set it's value to 0 and sift it up to it's new position
            self.heap[index] = 0;
            siftUp(self, index);
        }
        // now we just need to pop the minimum value
        popFromHeap(self);
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/aztec/AztecTypes.sol

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

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/interfaces/IDefiBridge.sol

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

// File: ../sc_datasets/DAppSCAN/Solidified-Aztec Lido Bridge/aztec-connect-bridges-d5aca13d4d0a17b21eeddf77f49f4c6613461fb0/src/bridges/element/ElementBridge.sol

// SPDX-License-Identifier: GPL-2.0-only
// Copyright 2020 Spilsbury Holdings Ltd
pragma solidity >=0.6.10 <=0.8.10;
pragma experimental ABIEncoderV2;









/**
 * @title Element Bridge
 * @dev Smart contract responsible for depositing, managing and redeeming Defi interactions with the Element protocol
 */

contract ElementBridge is IDefiBridge {
    using MinHeap for MinHeap.MinHeapData;

    /*----------------------------------------
      ERROR TAGS
      ----------------------------------------*/
    error INVALID_TRANCHE();
    error INVALID_WRAPPED_POSITION();
    error INVALID_POOL();
    error INVALID_CALLER();
    error ASSET_IDS_NOT_EQUAL();
    error ASSET_NOT_ERC20();
    error INTERACTION_ALREADY_EXISTS();
    error POOL_NOT_FOUND();
    error UNKNOWN_NONCE();
    error BRIDGE_NOT_READY();
    error ALREADY_FINALISED();
    error TRANCHE_POSITION_MISMATCH();
    error TRANCHE_UNDERLYING_MISMATCH();
    error POOL_UNDERLYING_MISMATCH();
    error POOL_EXPIRY_MISMATCH();
    error TRANCHE_EXPIRY_MISMATCH();
    error VAULT_ADDRESS_VERIFICATION_FAILED();
    error VAULT_ADDRESS_MISMATCH();
    error TRANCHE_ALREADY_EXPIRED();
    error UNREGISTERED_POOL();
    error UNREGISTERED_POSITION();
    error UNREGISTERED_PAIR();

    /*----------------------------------------
      STRUCTS
      ----------------------------------------*/
    /**
     * @dev Contains information that describes a specific interaction
     *
     * @param quantityPT the quantity of element principal tokens that were purchased by this interaction
     * @param trancheAddress the address of the element tranche for which principal tokens were purchased
     * @param expiry the time of expiry of this interaction's tranche
     * @param finalised flag specifying whether this interaction has been finalised
     * @param failed flag specifying whether this interaction failed to be finalised at any point
     */
    struct Interaction {
        uint256 quantityPT;
        address trancheAddress;
        uint64 expiry;
        bool finalised;
        bool failed;
    }

    /**
     * @dev Contains information that describes a specific element pool
     *
     * @param poolId the unique Id associated with the element pool
     * @param trancheAddress the address of the element tranche for which principal tokens are traded in the pool
     * @param poolAddress the address of the pool contract
     * @param wrappedPositionAddress the address of the underlying wrapped position token associated with the pool/tranche
     */
    struct Pool {
        bytes32 poolId;
        address trancheAddress;
        address poolAddress;
        address wrappedPositionAddress;
    }

    enum TrancheRedemptionStatus { NOT_REDEEMED, REDEMPTION_FAILED, REDEMPTION_SUCCEEDED }

    /**
     * @dev Contains information for managing all funds deposited/redeemed with a specific element tranche
     *
     * @param quantityTokensHeld total quantity of principal tokens purchased for the tranche
     * @param quantityAssetRedeemed total quantity of underlying tokens received from the element tranche on expiry
     * @param quantityAssetRemaining the current remainning quantity of underlying tokens held by the contract
     * @param numDeposits the total number of deposits (interactions) against the give tranche
     * @param numFinalised the current number of interactions against this tranche that have been finalised
     * @param redemptionStatus value describing the redemption status of the tranche
     */
    struct TrancheAccount {
        uint256 quantityTokensHeld;
        uint256 quantityAssetRedeemed;
        uint256 quantityAssetRemaining;
        uint32 numDeposits;
        uint32 numFinalised;
        TrancheRedemptionStatus redemptionStatus;
    }

    // Tranche factory address for Tranche contract address derivation
    address private immutable trancheFactory;
    // Tranche bytecode hash for Tranche contract address derivation.
    // This is constant as long as Tranche does not implement non-constant constructor arguments.
    bytes32 private immutable trancheBytecodeHash; // = 0xf481a073666136ab1f5e93b296e84df58092065256d0db23b2d22b62c68e978d;

    // cache of all of our Defi interactions. keyed on nonce
    mapping(uint256 => Interaction) public interactions;

    // cahce of all expiry values against the underlying asset address
    mapping(address => uint64[]) public assetToExpirys;

    // cache of all pools we have been configured to interact with
    mapping(uint256 => Pool) public pools;

    // cahce of all of our tranche accounts
    mapping(address => TrancheAccount) private trancheAccounts;

    // mapping containing the block number in which a tranche was configured
    mapping (address => uint256) private trancheDeploymentBlockNumbers;

    // the aztec rollup processor contract
    address public immutable rollupProcessor;

    // the balancer contract
    address private immutable balancerAddress;

    // the address of the element deployment validator contract
    address private immutable elementDeploymentValidatorAddress;

    // data structures used to manage the ongoing interaction deposit/redemption cycle
    MinHeap.MinHeapData private heap;
    mapping(uint64 => uint256[]) private expiryToNonce;

    // 48 hours in seconds, usd for calculating speeedbump expiries
    uint256 internal constant _FORTY_EIGHT_HOURS = 172800;

    uint256 internal constant MAX_INT = 2**256 - 1;

    uint256 internal constant MIN_GAS_FOR_CHECK_AND_FINALISE = 50000;
    uint256 internal constant MIN_GAS_FOR_FUNCTION_COMPLETION = 5000;
    uint256 internal constant MIN_GAS_FOR_FAILED_INTERACTION = 20000;
    uint256 internal constant MIN_GAS_FOR_EXPIRY_REMOVAL = 25000;

    // event emitted on every successful convert call
    event Convert(uint256 indexed nonce, uint256 totalInputValue);

    // event emitted on every attempt to finalise, successful or otherwise
    event Finalise(uint256 indexed nonce, bool success, string message);

    // event emitted on wvery newly configured pool
    event PoolAdded(address poolAddress, address wrappedPositionAddress, uint64 expiry);

    /**
     * @dev Constructor
     * @param _rollupProcessor the address of the rollup contract
     * @param _trancheFactory the address of the element tranche factor contract
     * @param _trancheBytecodeHash the hash of the bytecode of the tranche contract, used for tranche contract address derivation
     * @param _balancerVaultAddress the address of the balancer router contract
     * @param _elementDeploymentValidatorAddress the address of the element deployment validator contract
     */
    constructor(
        address _rollupProcessor,
        address _trancheFactory,
        bytes32 _trancheBytecodeHash,
        address _balancerVaultAddress,
        address _elementDeploymentValidatorAddress
    ) {
        rollupProcessor = _rollupProcessor;
        trancheFactory = _trancheFactory;
        trancheBytecodeHash = _trancheBytecodeHash;
        balancerAddress = _balancerVaultAddress;
        elementDeploymentValidatorAddress = _elementDeploymentValidatorAddress;
        heap.initialise(100);
    }

    /**
     * @dev Function for retrieving the available expiries for the given asset
     * @param asset the asset address being queried
     * @return assetExpiries the list of available expiries for the provided asset address
     */
    function getAssetExpiries(address asset) public view returns (uint64[] memory assetExpiries) {
        assetExpiries = assetToExpirys[asset];
    }

    /// @dev Registers a convergent pool with the contract, setting up a new asset/expiry element tranche
    /// @param _convergentPool The pool's address
    /// @param _wrappedPosition The element wrapped position contract's address
    /// @param _expiry The expiry of the tranche being configured
    function registerConvergentPoolAddress(
        address _convergentPool,
        address _wrappedPosition,
        uint64 _expiry
    ) external {
        checkAndStorePoolSpecification(_convergentPool, _wrappedPosition, _expiry);
    }

    /// @dev This internal function produces the deterministic create2
    ///      address of the Tranche contract from a wrapped position contract and expiry
    /// @param position The wrapped position contract address
    /// @param expiry The expiration time of the tranche as a uint256
    /// @return trancheContract derived Tranche contract address
    function deriveTranche(address position, uint256 expiry) internal view virtual returns (address trancheContract) {
        bytes32 salt = keccak256(abi.encodePacked(position, expiry));
        bytes32 addressBytes = keccak256(abi.encodePacked(bytes1(0xff), trancheFactory, salt, trancheBytecodeHash));
        trancheContract = address(uint160(uint256(addressBytes)));
    }

    struct PoolSpec {
        uint256 poolExpiry;
        bytes32 poolId;
        address underlyingAsset;
        address trancheAddress;
        address tranchePosition;
        address trancheUnderlying;
        address poolUnderlying;
        address poolVaultAddress;
    }

    /// @dev Validates and stores a convergent pool specification
    /// @param poolAddress The pool's address
    /// @param wrappedPositionAddress The element wrapped position contract's address
    /// @param expiry The expiry of the tranche being configured
    function checkAndStorePoolSpecification(
        address poolAddress,
        address wrappedPositionAddress,
        uint64 expiry        
    ) internal {
        PoolSpec memory poolSpec;
        IWrappedPosition wrappedPosition = IWrappedPosition(wrappedPositionAddress);
        // this underlying asset should be the real asset i.e. DAI stablecoin etc
        try wrappedPosition.token() returns (IERC20 wrappedPositionToken) {
            poolSpec.underlyingAsset = address(wrappedPositionToken);
        } catch {
            revert INVALID_WRAPPED_POSITION();
        }
        // this should be the address of the Element tranche for the asset/expiry pair
        poolSpec.trancheAddress = deriveTranche(wrappedPositionAddress, expiry);
        // get the wrapped position held in the tranche to cross check against that provided
        ITranche tranche = ITranche(poolSpec.trancheAddress);
        try tranche.position() returns (IERC20 tranchePositionToken) {
            poolSpec.tranchePosition = address(tranchePositionToken);
        } catch {
            revert INVALID_TRANCHE();
        }
        // get the underlying held in the tranche to cross check against that provided
        try tranche.underlying() returns (IERC20 trancheUnderlying) {
            poolSpec.trancheUnderlying = address(trancheUnderlying);
        } catch {
            revert INVALID_TRANCHE();
        }
        // get the tranche expiry to cross check against that provided
        uint64 trancheExpiry = 0;
        try tranche.unlockTimestamp() returns (uint256 trancheUnlock) {
            trancheExpiry = uint64(trancheUnlock);
        } catch {
            revert INVALID_TRANCHE();
        }
        if (trancheExpiry != expiry) {
            revert TRANCHE_EXPIRY_MISMATCH();
        }

        if (poolSpec.tranchePosition != wrappedPositionAddress) {
            revert TRANCHE_POSITION_MISMATCH();
        }
        if (poolSpec.trancheUnderlying != poolSpec.underlyingAsset) {
            revert TRANCHE_UNDERLYING_MISMATCH();
        }
        // get the pool underlying to cross check against that provided
        IPool pool = IPool(poolAddress);
        try pool.underlying() returns (IERC20 poolUnderlying) {
            poolSpec.poolUnderlying = address(poolUnderlying);
        } catch {
            revert INVALID_POOL();
        }
        // get the pool expiry to cross check against that provided
        try pool.expiration() returns (uint256 poolExpiry) {
            poolSpec.poolExpiry = poolExpiry;
        } catch {
            revert INVALID_POOL();
        }
        // get the vault associated with the pool
        try pool.getVault() returns (IVault poolVault) {
            poolSpec.poolVaultAddress = address(poolVault);
        } catch {
            revert INVALID_POOL();
        }
        // get the pool id associated with the pool
        try pool.getPoolId() returns (bytes32 poolId) {
            poolSpec.poolId = poolId;
        } catch {
            revert INVALID_POOL();
        }
        if (poolSpec.poolUnderlying != poolSpec.underlyingAsset) {
            revert POOL_UNDERLYING_MISMATCH();
        }
        if (poolSpec.poolExpiry != expiry) {
            revert POOL_EXPIRY_MISMATCH();
        }
        //verify that the vault address is equal to our balancer address
        if (poolSpec.poolVaultAddress != balancerAddress) {
            revert VAULT_ADDRESS_VERIFICATION_FAILED();
        }

        // retrieve the pool address for the given pool id from balancer
        // then test it against that given to us
        IVault balancerVault = IVault(balancerAddress);
        (address balancersPoolAddress, ) = balancerVault.getPool(poolSpec.poolId);
        if (poolAddress != balancersPoolAddress) {
            revert VAULT_ADDRESS_MISMATCH();
        }

        // verify with Element that the provided contracts are registered
        validatePositionAndPoolAddresses(wrappedPositionAddress, poolAddress);

        // we store the pool information against a hash of the asset and expiry
        uint256 assetExpiryHash = hashAssetAndExpiry(poolSpec.underlyingAsset, trancheExpiry);
        pools[assetExpiryHash] = Pool(poolSpec.poolId, poolSpec.trancheAddress, poolAddress, wrappedPositionAddress);
        uint64[] storage expiriesForAsset = assetToExpirys[poolSpec.underlyingAsset];
        uint256 expiryIndex = 0;
        while (expiryIndex < expiriesForAsset.length && expiriesForAsset[expiryIndex] != trancheExpiry) {
            ++expiryIndex;
        }
        if (expiryIndex == expiriesForAsset.length) {
            expiriesForAsset.push(trancheExpiry);
        }
        setTrancheDeploymentBlockNumber(poolSpec.trancheAddress);
        
        // initialising the expiry -> nonce mapping here like this reduces a chunk of gas later when we start to add interactions for this expiry
        uint256[] storage nonces = expiryToNonce[trancheExpiry];
        if (nonces.length == 0) {
            expiryToNonce[trancheExpiry].push(MAX_INT);
        }
        emit PoolAdded(poolAddress, wrappedPositionAddress, trancheExpiry);
    }

    /**
    * @dev Sets the current block number as the block in which the given tranche was first configured
    * Only stores the block number if this is the first time this tranche has been configured
    * @param trancheAddress the address of the tranche against which to store the current block number
     */
    function setTrancheDeploymentBlockNumber(address trancheAddress) internal {
        uint256 trancheDeploymentBlock = trancheDeploymentBlockNumbers[trancheAddress];
        if (trancheDeploymentBlock == 0) {
            // only set the deployment block on the first time this tranche is configured
            trancheDeploymentBlockNumbers[trancheAddress] = block.number;
        }
    }

    /**
    * @dev Returns the block number in which a tranche was first configured on the bridge based on the nonce of an interaction in that tranche
    * @param interactionNonce the nonce of the interaction to query
    * @return blockNumber the number of the block in which the tranche was first configured
     */
    function getTrancheDeploymentBlockNumber(uint256 interactionNonce) public view returns (uint256 blockNumber) {
        Interaction storage interaction = interactions[interactionNonce];
        if (interaction.expiry == 0) {
            revert UNKNOWN_NONCE();
        }
        blockNumber = trancheDeploymentBlockNumbers[interaction.trancheAddress];
    }

    /**
    * @dev Verifies that the given pool and wrapped position addresses are registered in the Element deployment validator
    * Reverts if addresses don't validate successfully
    * @param wrappedPosition address of a wrapped position contract
    * @param pool address of a balancer pool contract
     */
    function validatePositionAndPoolAddresses(address wrappedPosition, address pool) internal {
        IDeploymentValidator validator = IDeploymentValidator(elementDeploymentValidatorAddress);
        if (!validator.checkPoolValidation(pool)) {
            revert UNREGISTERED_POOL();
        }
        if (!validator.checkWPValidation(wrappedPosition)) {
            revert UNREGISTERED_POSITION();
        }
        if (!validator.checkPairValidation(wrappedPosition, pool)) {
            revert UNREGISTERED_PAIR();
        }
    }

    /// @dev Produces a hash of the given asset and expiry value
    /// @param asset The asset address
    /// @param expiry The expiry value
    /// @return hashValue The resulting hash value
    function hashAssetAndExpiry(address asset, uint64 expiry) public pure returns (uint256 hashValue) {
        hashValue = uint256(keccak256(abi.encodePacked(asset, uint256(expiry))));
    }

    /**
     * @dev Function to add a new interaction to the bridge
     * Converts the amount of input asset given to the market determined amount of tranche asset
     * @param inputAssetA The type of input asset for the new interaction
     * @param outputAssetA The type of output asset for the new interaction
     * @param totalInputValue The amount the the input asset provided in this interaction
     * @param interactionNonce The nonce value for this interaction
     * @param auxData The expiry value for this interaction
     * @return outputValueA The interaction's first ouptut value after this call - will be 0
     * @return outputValueB The interaction's second ouptut value after this call - will be 0
     * @return isAsync Flag specifying if this interaction is asynchronous - will be true
     */
    function convert(
        AztecTypes.AztecAsset calldata inputAssetA,
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata outputAssetA,
        AztecTypes.AztecAsset calldata,
        uint256 totalInputValue,
        uint256 interactionNonce,
        uint64 auxData,
        address
    )
        external
        payable
        override
        returns (
            uint256 outputValueA,
            uint256 outputValueB,
            bool isAsync
        )
    {
        // ### INITIALIZATION AND SANITY CHECKS
        if (msg.sender != rollupProcessor) {
            revert INVALID_CALLER();
        }
        if (inputAssetA.id != outputAssetA.id) {
            revert ASSET_IDS_NOT_EQUAL();
        }
        if (inputAssetA.assetType != AztecTypes.AztecAssetType.ERC20) {
            revert ASSET_NOT_ERC20();
        }
        if (interactions[interactionNonce].expiry != 0) {
            revert INTERACTION_ALREADY_EXISTS();
        }
        
        // operation is asynchronous
        isAsync = true;
        outputValueA = 0;
        outputValueB = 0;
        // retrieve the appropriate pool for this interaction and verify that it exists
        Pool storage pool = pools[hashAssetAndExpiry(inputAssetA.erc20Address, auxData)];
        if (pool.trancheAddress == address(0)) {
            revert POOL_NOT_FOUND();
        }
        ITranche tranche = ITranche(pool.trancheAddress);
        if (block.timestamp >= tranche.unlockTimestamp()) {
            revert TRANCHE_ALREADY_EXPIRED();
        }
        uint64 trancheExpiry = uint64(tranche.unlockTimestamp());
        // approve the transfer of tokens to the balancer address
        ERC20(inputAssetA.erc20Address).approve(balancerAddress, totalInputValue);
        // execute the swap on balancer
        address inputAsset = inputAssetA.erc20Address;

        uint256 principalTokensAmount = IVault(balancerAddress).swap(
            IVault.SingleSwap({
                poolId: pool.poolId,
                kind: IVault.SwapKind.GIVEN_IN,
                assetIn: IAsset(inputAsset),
                assetOut: IAsset(pool.trancheAddress),
                amount: totalInputValue,
                userData: '0x00'
            }),
            IVault.FundManagement({
                sender: address(this), // the bridge has already received the tokens from the rollup so it owns totalInputValue of inputAssetA
                fromInternalBalance: false,
                recipient: payable(address(this)),
                toInternalBalance: false
            }),
            totalInputValue,
            block.timestamp
        );
        // store the tranche that underpins our interaction, the expiry and the number of received tokens against the nonce
        Interaction storage newInteraction = interactions[interactionNonce];
        newInteraction.expiry = trancheExpiry;
        newInteraction.failed = false;
        newInteraction.finalised = false;
        newInteraction.quantityPT = principalTokensAmount;
        newInteraction.trancheAddress = pool.trancheAddress;
        // add the nonce and expiry to our expiry heap
        addNonceAndExpiry(interactionNonce, trancheExpiry);
        // increase our tranche account deposits and holdings
        // other members are left as their initial values (all zeros)
        TrancheAccount storage trancheAccount = trancheAccounts[newInteraction.trancheAddress];
        trancheAccount.numDeposits++;
        trancheAccount.quantityTokensHeld += newInteraction.quantityPT;
        emit Convert(interactionNonce, totalInputValue);
        finaliseExpiredInteractions(MIN_GAS_FOR_FUNCTION_COMPLETION);       
        // we need to get here with MIN_GAS_FOR_FUNCTION_COMPLETION gas to exit.
    }

    /**
     * @dev Function to attempt finalising of as many interactions as possible within the specified gas limit
     * Continue checking for and finalising interactions until we expend the available gas
     * @param gasFloor The amount of gas that needs to remain after this call has completed
     */
    function finaliseExpiredInteractions(uint256 gasFloor) internal {
        // check and finalise interactions until we don't have enough gas left to reliably update our state without risk of reverting the entire transaction
        // gas left must be enough for check for next expiry, finalise and leave this function without breaching gasFloor
        uint256 gasLoopCondition = MIN_GAS_FOR_CHECK_AND_FINALISE + MIN_GAS_FOR_FUNCTION_COMPLETION + gasFloor;
        uint256 ourGasFloor = MIN_GAS_FOR_FUNCTION_COMPLETION + gasFloor;
        while (gasleft() > gasLoopCondition) {
            // check the heap to see if we can finalise an expired transaction
            // we provide a gas floor to the function which will enable us to leave this function without breaching our gasFloor
            (bool expiryAvailable, uint256 nonce) = checkNextExpiry(ourGasFloor);
            if (!expiryAvailable) {
                break;
            }
            // make sure we will have at least ourGasFloor gas after the finalise in order to exit this function
            uint256 gasRemaining = gasleft();
            if (gasRemaining <= ourGasFloor) {
                break;
            }
            uint256 gasForFinalise = gasRemaining - ourGasFloor;
            // make the call to finalise the interaction with the gas limit        
            try IRollupProcessor(rollupProcessor).processAsyncDefiInteraction{gas: gasForFinalise}(nonce) returns (bool interactionCompleted) {
                // no need to do anything here, we just need to know that the call didn't throw
            } catch {
                break;
            }
        }
    }

    /**
     * @dev Function to finalise an interaction
     * Converts the held amount of tranche asset for the given interaction into the output asset
     * @param interactionNonce The nonce value for the interaction that should be finalised
     */
    function finalise(
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata,
        AztecTypes.AztecAsset calldata outputAssetA,
        AztecTypes.AztecAsset calldata,
        uint256 interactionNonce,
        uint64
    )
        external
        payable
        override
        returns (
            uint256 outputValueA,
            uint256 outputValueB,
            bool interactionCompleted
        )
    {
        if (msg.sender != rollupProcessor) {
            revert INVALID_CALLER();
        }
        // retrieve the interaction and verify it's ready for finalising
        Interaction storage interaction = interactions[interactionNonce];
        if (interaction.expiry == 0) {
            revert UNKNOWN_NONCE();
        }
        if (interaction.expiry > block.timestamp) {
            revert BRIDGE_NOT_READY();
        }
        if (interaction.finalised) {
            revert ALREADY_FINALISED();
        }

        TrancheAccount storage trancheAccount = trancheAccounts[interaction.trancheAddress];
        if (trancheAccount.numDeposits == 0) {
            // shouldn't be possible, this means we have had no deposits against this tranche
            setInteractionAsFailure(interaction, interactionNonce, 'NO_DEPOSITS_FOR_TRANCHE');
            popInteraction(interaction, interactionNonce);
            return (0, 0, false);
        }

        // we only want to redeem the tranche if it hasn't previously successfully been redeemed
        if (trancheAccount.redemptionStatus != TrancheRedemptionStatus.REDEMPTION_SUCCEEDED) {
            // tranche not redeemed, we need to withdraw the principal
            // convert the tokens back to underlying using the tranche
            ITranche tranche = ITranche(interaction.trancheAddress);
            try tranche.withdrawPrincipal(trancheAccount.quantityTokensHeld, address(this)) returns (uint256 valueRedeemed) {
                trancheAccount.quantityAssetRedeemed = valueRedeemed;
                trancheAccount.quantityAssetRemaining = valueRedeemed;
                trancheAccount.redemptionStatus = TrancheRedemptionStatus.REDEMPTION_SUCCEEDED;
            } catch Error(string memory errorMessage) {
                setInteractionAsFailure(interaction, interactionNonce, errorMessage);
                trancheAccount.redemptionStatus = TrancheRedemptionStatus.REDEMPTION_FAILED;
                popInteraction(interaction, interactionNonce);
                return (0, 0, false);
            } catch {
                setInteractionAsFailure(interaction, interactionNonce, 'UNKNOWN_ERROR_FROM_TRANCHE_WITHDRAW');
                trancheAccount.redemptionStatus = TrancheRedemptionStatus.REDEMPTION_FAILED;
                popInteraction(interaction, interactionNonce);
                return (0, 0, false);
            }
        }

        // at this point, the tranche must have been redeemed and we can allocate proportionately to this interaction
        uint256 amountToAllocate = 0;
        if (trancheAccount.quantityTokensHeld == 0) {
            // what can we do here? 
            // we seem to have 0 total principle tokens so we can't apportion the output asset as it must be the case that each interaction purchased 0
            // we know that the number of deposits against this tranche is > 0 as we check further up this function
            // so we will have to divide the output asset, if there is any, equally
            amountToAllocate = trancheAccount.quantityAssetRedeemed / trancheAccount.numDeposits;
        } else {
            // apportion the output asset based on the interaction's holding of the principle token
            amountToAllocate = (trancheAccount.quantityAssetRedeemed * interaction.quantityPT) / trancheAccount.quantityTokensHeld;
        }
        // numDeposits and numFinalised are uint32 types, so easily within range for an int256
        int256 numRemainingInteractionsForTranche = int256(uint256(trancheAccount.numDeposits)) - int256(uint256(trancheAccount.numFinalised));
        // the number of remaining interactions should never be less than 1 here, but test for <= 1 to ensure we catch all possibilities
        if (numRemainingInteractionsForTranche <= 1 || amountToAllocate > trancheAccount.quantityAssetRemaining) {
            // if there are no more interactions to finalise after this then allocate all the remaining
            // likewise if we have managed to allocate more than the remaining
            amountToAllocate = trancheAccount.quantityAssetRemaining;
        }
        trancheAccount.quantityAssetRemaining -= amountToAllocate;
        trancheAccount.numFinalised++;

        // approve the transfer of funds back to the rollup contract
        ERC20(outputAssetA.erc20Address).approve(rollupProcessor, amountToAllocate);
        interaction.finalised = true;
        popInteraction(interaction, interactionNonce);
        outputValueA = amountToAllocate;
        outputValueB = 0;
        interactionCompleted = true;
        emit Finalise(interactionNonce, interactionCompleted, '');
    }

    /**
     * @dev Function to mark an interaction as having failed and publish a finalise event
     * @param interaction The interaction that failed
     * @param interactionNonce The nonce of the failed interaction
     * @param message The reason for failure
     */
    function setInteractionAsFailure(
        Interaction storage interaction,
        uint256 interactionNonce,
        string memory message
    ) internal {
        interaction.failed = true;
        emit Finalise(interactionNonce, false, message);
    }

    /**
     * @dev Function to add an interaction nonce and expiry to the heap data structures
     * @param nonce The nonce of the interaction to be added
     * @param expiry The expiry of the interaction to be added
     * @return expiryAdded Flag specifying whether the interactions expiry was added to the heap
     */
    function addNonceAndExpiry(uint256 nonce, uint64 expiry) internal returns (bool expiryAdded) {
        // get the set of nonces already against this expiry
        // check for the MAX_INT placeholder nonce that exists to reduce gas costs at this point in the code
        expiryAdded = false;
        uint256[] storage nonces = expiryToNonce[expiry];
        if (nonces.length == 1 && nonces[0] == MAX_INT) {
            nonces[0] = nonce;
        } else {
            nonces.push(nonce);
        }
        // is this the first time this expiry has been requested?
        // if so then add it to our expiry heap
        if (nonces.length == 1) {
            heap.add(expiry);
            expiryAdded = true;
        }
    }

    /**
     * @dev Function to remove an interaction from the heap data structures
     * @param interaction The interaction should be removed
     * @param interactionNonce The nonce of the interaction to be removed
     * @return expiryRemoved Flag specifying whether the interactions expiry was removed from the heap
     */
    function popInteraction(Interaction storage interaction, uint256 interactionNonce) internal returns (bool expiryRemoved) {
        uint256[] storage nonces = expiryToNonce[interaction.expiry];
        if (nonces.length == 0) {
            return (false);
        }
        uint256 index = nonces.length - 1;
        while (index > 0 && nonces[index] != interactionNonce) {
            --index;
        }
        if (nonces[index] != interactionNonce) {
            return (false);
        }
        if (index != nonces.length - 1) {
            nonces[index] = nonces[nonces.length - 1];
        }
        nonces.pop();

        // if there are no more nonces left for this expiry then remove it from the heap
        if (nonces.length == 0) {
            heap.remove(interaction.expiry);
            delete expiryToNonce[interaction.expiry];
            return (true);
        }
        return (false);
    }

    /**
     * @dev Function to determine if we are able to finalise an interaction
     * @param gasFloor The amount of gas that needs to remain after this call has completed
     * @return expiryAvailable Flag specifying whether an expiry is available to be finalised
     * @return nonce The next interaction nonce to be finalised
     */
    function checkNextExpiry(uint256 gasFloor)
        internal
        returns (
            bool expiryAvailable,
            uint256 nonce
        )
    {
        // do we have any expiries and if so is the earliest expiry now expired
        if (heap.size() == 0) {
            return (false, 0);
        }
        // retrieve the minimum (oldest) expiry and determine if it is in the past
        uint64 nextExpiry = heap.min();
        if (nextExpiry > block.timestamp) {
            // oldest expiry is still not expired
            return (false, 0);
        }
        // we have some expired interactions
        uint256[] storage nonces = expiryToNonce[nextExpiry];
        uint256 minGasForLoop = (gasFloor + MIN_GAS_FOR_FAILED_INTERACTION);
        while (nonces.length > 0 && gasleft() >= minGasForLoop) {
            uint256 nextNonce = nonces[nonces.length - 1];
            if (nextNonce == MAX_INT) {
                // this shouldn't happen, this value is the placeholder for reducing gas costs on convert
                // we just need to pop and continue
                nonces.pop();
                continue;
            }
            Interaction storage interaction = interactions[nextNonce];
            if (interaction.expiry == 0 || interaction.finalised || interaction.failed) {
                // this shouldn't happen, suggests the interaction has been finalised already but not removed from the sets of nonces for this expiry
                // remove the nonce and continue searching
                nonces.pop();
                continue;
            }
            // we have valid interaction for the next expiry, check if it can be finalised
            (bool canBeFinalised, string memory message) = interactionCanBeFinalised(interaction);
            if (!canBeFinalised) {
                // can't be finalised, add to failures and pop from nonces
                setInteractionAsFailure(interaction, nextNonce, message);
                nonces.pop();
                continue;
            }
            return (true, nextNonce);
        }

        // if we don't have enough gas to remove the expiry, it will be removed next time
        if (nonces.length == 0 && gasleft() >= (gasFloor + MIN_GAS_FOR_EXPIRY_REMOVAL)) {
            // if we are here then we have run out of nonces for this expiry so pop from the heap
            heap.remove(nextExpiry);
        }
        return (false, 0);
    }

    /**
     * @dev Determine if an interaction can be finalised
     * Performs a variety of check on the tranche and tranche account to determine 
     * a. if the tranche has already been redeemed
     * b. if the tranche is currently under a speedbump
     * c. if the yearn vault has sufficient balance to support tranche redemption
     * @param interaction The interaction to be finalised
     * @return canBeFinalised Flag specifying whether the interaction can be finalised
     * @return message Message value giving the reason why an interaction can't be finalised
     */
    function interactionCanBeFinalised(Interaction storage interaction) internal returns (bool canBeFinalised, string memory message) {
        TrancheAccount storage trancheAccount = trancheAccounts[interaction.trancheAddress];
        if (trancheAccount.numDeposits == 0) {
            // shouldn't happen, suggests we don't have an account for this tranche!
            return (false, 'NO_DEPOSITS_FOR_TRANCHE');
        }
        if (trancheAccount.redemptionStatus == TrancheRedemptionStatus.REDEMPTION_FAILED) {
            return (false, 'TRANCHE_REDEMPTION_FAILED');
        }
        // determine if the tranche has already been redeemed
        if (trancheAccount.redemptionStatus == TrancheRedemptionStatus.REDEMPTION_SUCCEEDED) {
            // tranche was previously redeemed
            if (trancheAccount.quantityAssetRemaining == 0) {
                // this is a problem. we have already allocated out all of the redeemed assets!
                return (false, 'ASSET_ALREADY_FULLY_ALLOCATED');
            }
            // this interaction can be finalised. we don't need to redeem the tranche, we just need to allocate the redeemed asset
            return (true, '');
        }
        // tranche hasn't been redeemed, now check to see if we can redeem it
        ITranche tranche = ITranche(interaction.trancheAddress);
        uint256 speedbump = tranche.speedbump();
        if (speedbump != 0) {
            uint256 newExpiry = speedbump + _FORTY_EIGHT_HOURS;
            if (newExpiry > block.timestamp) {
                // a speedbump is in force for this tranche and it is beyond the current time
                trancheAccount.redemptionStatus = TrancheRedemptionStatus.REDEMPTION_FAILED;
                return (false, 'SPEEDBUMP');
            }
        }
        address wpAddress = address(tranche.position());
        IWrappedPosition wrappedPosition = IWrappedPosition(wpAddress);
        address underlyingAddress = address(wrappedPosition.token());
        address yearnVaultAddress = address(wrappedPosition.vault());
        uint256 vaultQuantity = ERC20(underlyingAddress).balanceOf(yearnVaultAddress);
        if (trancheAccount.quantityTokensHeld > vaultQuantity) {
            trancheAccount.redemptionStatus = TrancheRedemptionStatus.REDEMPTION_FAILED;
            return (false, 'VAULT_BALANCE');
        }
        // at this point, we will need to redeem the tranche which should be possible
        return (true, '');
    }
}
