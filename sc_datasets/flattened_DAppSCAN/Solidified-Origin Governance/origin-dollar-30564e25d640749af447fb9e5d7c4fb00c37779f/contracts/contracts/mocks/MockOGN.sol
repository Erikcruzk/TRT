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

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/mocks/BurnableERC20.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IBurnableERC20 {
    function burn(uint256 value) external returns (bool);

    function burnFrom(address account, uint256 value) external returns (bool);
}

/**
 * @title BurnableERC20
 * @dev Exposes the burn function of ERC20 for tests
 */
abstract contract BurnableERC20 is IBurnableERC20, ERC20 {
    /**
     * @dev Function to burn tokens
     * @param value The amount of tokens to burn.
     * @return A boolean that indicates if the operation was successful.
     */
    function burn(uint256 value) public virtual override returns (bool) {
        _burn(msg.sender, value);
        return true;
    }

    /**
     * @dev Function to burn tokens from a specific account
     * @param account The address with the tokens to burn.
     * @param value The amount of tokens to burn.
     * @return A boolean that indicates if the operation was successful.
     */
    function burnFrom(address account, uint256 value)
        public
        override
        returns (bool)
    {
        _burn(account, value);
        return true;
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/mocks/MintableERC20.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IMintableERC20 {
    function mint(uint256 value) external;

    function mintTo(address to, uint256 value) external;
}

/**
 * @title MintableERC20
 * @dev Exposes the mint function of ERC20 for tests
 */
abstract contract MintableERC20 is IMintableERC20, ERC20 {
    /**
     * @dev Function to mint tokens
     * @param _value The amount of tokens to mint.
     */
    function mint(uint256 _value) public virtual override {
        _mint(msg.sender, _value);
    }

    /**
     * @dev Function to mint tokens
     * @param _to Address to mint to.
     * @param _value The amount of tokens to mint.
     */
    function mintTo(address _to, uint256 _value) public virtual override {
        _mint(_to, _value);
    }
}

// File: ../sc_datasets/DAppSCAN/Solidified-Origin Governance/origin-dollar-30564e25d640749af447fb9e5d7c4fb00c37779f/contracts/contracts/mocks/MockOGN.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;


/**
 * @title Origin token (OGN).
 *
 * @dev Token that allows minting and burning.
 * @dev Important note:
 * @dev   There is a known race condition in the ERC20 standard on the approve() method.
 * @dev   See details: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
 * @dev   The Origin token contract implements the increaseApproval() and decreaseApproval() methods.
 * @dev   It is strongly recommended to use those methods rather than approve()
 * @dev   when updating the token allowance.
 */
contract MockOGN is MintableERC20, BurnableERC20 {
    event SetWhitelistExpiration(uint256 expiration);
    event AllowedTransactorAdded(address sender);
    event AllowedTransactorRemoved(address sender);
    event AddCallSpenderWhitelist(address enabler, address spender);
    event RemoveCallSpenderWhitelist(address disabler, address spender);

    mapping(address => bool) public callSpenderWhitelist;
    address public owner = msg.sender;
    // UNIX timestamp (in seconds) after which this whitelist no longer applies
    uint256 public whitelistExpiration;
    // While the whitelist is active, either the sender or recipient must be
    // in allowedTransactors.
    mapping(address => bool) public allowedTransactors;

    // @dev Constructor that gives msg.sender all initial tokens.
    constructor(uint256 _initialSupply) ERC20("OriginToken", "OGN") {
        owner = msg.sender;
        _mint(owner, _initialSupply);
    }

    //
    // approveAndCall methods
    //

    // @dev Add spender to whitelist of spenders for approveAndCall
    // @param _spender Address to add
    function addCallSpenderWhitelist(address _spender) public onlyOwner {
        callSpenderWhitelist[_spender] = true;
        emit AddCallSpenderWhitelist(msg.sender, _spender);
    }

    // @dev Remove spender from whitelist of spenders for approveAndCall
    // @param _spender Address to remove
    function removeCallSpenderWhitelist(address _spender) public onlyOwner {
        delete callSpenderWhitelist[_spender];
        emit RemoveCallSpenderWhitelist(msg.sender, _spender);
    }

    // @dev Approve transfer of tokens and make a contract call in a single
    // @dev transaction. This allows a DApp to avoid requiring two MetaMask
    // @dev approvals for a single logical action, such as creating a listing,
    // @dev which requires the seller to approve a token transfer and the
    // @dev marketplace contract to transfer tokens from the seller.
    //
    // @dev This is based on the ERC827 function approveAndCall and avoids
    // @dev security issues by only working with a whitelisted set of _spender
    // @dev addresses. The other difference is that the combination of this
    // @dev function ensures that the proxied function call receives the
    // @dev msg.sender for this function as its first parameter.
    //
    // @param _spender The address that will spend the funds.
    // @param _value The amount of tokens to be spent.
    // @param _selector Function selector for function to be called.
    // @param _callParams Packed, encoded parameters, omitting the first parameter which is always msg.sender
    function approveAndCallWithSender(
        address _spender,
        uint256 _value,
        bytes4 _selector,
        bytes memory _callParams
    ) public payable returns (bool) {
        require(_spender != address(this), "token contract can't be approved");
        require(callSpenderWhitelist[_spender], "spender not in whitelist");

        require(super.approve(_spender, _value), "approve failed");

        bytes memory callData = abi.encodePacked(
            _selector,
            uint256(uint160(msg.sender)),
            _callParams
        );
        // solium-disable-next-line security/no-call-value
        (bool success, ) = _spender.call{ value: msg.value }(callData);
        require(success, "proxied call failed");
        return true;
    }

    //
    // Functions for maintaining whitelist
    //

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier allowedTransfer(address _from, address _to) {
        require(
            // solium-disable-next-line operator-whitespace
            !whitelistActive() ||
                allowedTransactors[_from] ||
                allowedTransactors[_to],
            "neither sender nor recipient are allowed"
        );
        _;
    }

    function whitelistActive() public view returns (bool) {
        return block.timestamp < whitelistExpiration;
    }

    function addAllowedTransactor(address _transactor) public onlyOwner {
        emit AllowedTransactorAdded(_transactor);
        allowedTransactors[_transactor] = true;
    }

    function removeAllowedTransactor(address _transactor) public onlyOwner {
        emit AllowedTransactorRemoved(_transactor);
        delete allowedTransactors[_transactor];
    }

    /**
     * @dev Set the whitelist expiration, after which the whitelist no longer
     * applies.
     */
    function setWhitelistExpiration(uint256 _expiration) public onlyOwner {
        // allow only if whitelist expiration hasn't yet been set, or if the
        // whitelist expiration hasn't passed yet
        require(
            whitelistExpiration == 0 || whitelistActive(),
            "an expired whitelist cannot be extended"
        );
        // prevent possible mistakes in calling this function
        require(
            _expiration >= block.timestamp + 1 days,
            "whitelist expiration not far enough into the future"
        );
        emit SetWhitelistExpiration(_expiration);
        whitelistExpiration = _expiration;
    }

    //
    // ERC20 transfer functions that have been overridden to enforce the
    // whitelist.
    //

    function transfer(address _to, uint256 _value)
        public
        override
        allowedTransfer(msg.sender, _to)
        returns (bool)
    {
        return super.transfer(_to, _value);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override allowedTransfer(_from, _to) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }
}
