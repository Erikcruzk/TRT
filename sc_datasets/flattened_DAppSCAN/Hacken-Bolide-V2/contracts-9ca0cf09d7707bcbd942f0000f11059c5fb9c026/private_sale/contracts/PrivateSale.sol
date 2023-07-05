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

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// File: @openzeppelin/contracts/utils/Address.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.1;

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
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
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
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    /**
     * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    /**
     * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
     * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
     */
    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 oldAllowance = token.allowance(address(this), spender);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
    }

    /**
     * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful.
     */
    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
        }
    }

    /**
     * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
     * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
     * 0 before setting it to a non-zero value.
     */
    function forceApprove(IERC20 token, address spender, uint256 value) internal {
        bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);

        if (!_callOptionalReturnBool(token, approvalCall)) {
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
            _callOptionalReturn(token, approvalCall);
        }
    }

    /**
     * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
     * Revert on invalid signature.
     */
    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     *
     * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
     */
    function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
        // and not revert is the subcall reverts.

        (bool success, bytes memory returndata) = address(token).call(data);
        return
            success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
    }
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

// File: ../sc_datasets/DAppSCAN/Hacken-Bolide-V2/contracts-9ca0cf09d7707bcbd942f0000f11059c5fb9c026/private_sale/contracts/TokenVestingGroup.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;



contract TokenVestingGroup is Ownable {
    using SafeERC20 for IERC20;

    event TokensReleased(address token, uint256 amount);

    mapping(address => uint256) _sumUser;
    mapping(address => uint256) _rateToken;
    mapping(address => uint256) _released;
    mapping(address => address) _userToken;
    address[] _tokens;
    IERC20 public _token;

    // Durations and timestamps are expressed in UNIX time, the same units as block.timestamp.
    uint256 private _durationCount;
    uint256 private _startTimestamp;
    uint256 private _duration;
    uint256 private _endTimestamp;

    /**
     * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
     * beneficiary. By then all
     * of the balance will have vested.
     */
    constructor(
        address tokenValue,
        uint256 durationValue,
        uint256 durationCountValue,
        address[] memory tokensValue
    ) {
        _token = IERC20(tokenValue);
        _duration = durationValue;
        _durationCount = durationCountValue;
        _tokens = tokensValue;
    }

    /**
     * @notice Set amount of token for user deposited token
     */
    function deposit(
        address user,
        address token,
        uint256 amount
    ) external onlyOwner {
        _userToken[user] = token;
        _sumUser[user] = amount;
    }

    /**
     * @notice Transfers vested tokens to beneficiary.
     */
    function finishRound(uint256 startTimestampValue, uint256[] memory tokenRate) external onlyOwner {
        require(_startTimestamp == 0, "Vesting has been started");
        _startTimestamp = startTimestampValue;
        for (uint256 i = 0; i < tokenRate.length; i++) {
            _rateToken[_tokens[i]] = tokenRate[i];
        }
    }

    /**
     * @notice Transfers vested tokens to beneficiary.
     */
    function claim() external {
        uint256 unreleased = releasableAmount();

        require(unreleased > 0, "TokenVesting: no tokens are due");

        _released[msg.sender] = _released[msg.sender] + (unreleased);

        _token.safeTransfer(msg.sender, unreleased);

        emit TokensReleased(address(_token), unreleased);
    }

    /**
     * @notice Set 0 for user deposited token
     */
    function returnDeposit(address user) external onlyOwner {
        require(_startTimestamp == 0, "Vesting has been started");
        _userToken[user] = address(0);
        _sumUser[user] = 0;
    }

    /**
     * @return the end time of the token vesting.
     */
    function end() public view returns (uint256) {
        return _startTimestamp + _duration * _durationCount;
    }

    /**
     * @return the start time of the token vesting.
     */
    function start() public view returns (uint256) {
        return _startTimestamp;
    }

    /**
     * @return the duration of the token vesting.
     */
    function duration() public view returns (uint256) {
        return _duration;
    }

    /**
     * @return the count of duration  of the token vesting.
     */
    function durationCount() public view returns (uint256) {
        return _durationCount;
    }

    /**
     * @return the amount of the token released.
     */
    function released(address account) public view returns (uint256) {
        return _released[account];
    }

    /**
     * @dev Calculates the amount that has already vested but hasn't been released yet.
     */
    function releasableAmount() public view returns (uint256) {
        return _vestedAmount(msg.sender) - (_released[msg.sender]);
    }

    /**
     * @dev Calculates the user dollar deposited.
     */
    function getUserShare(address account) public view returns (uint256) {
        return (_sumUser[account] * _rateToken[_userToken[account]]) / (1 ether);
    }

    /**
     * @dev Calculates the amount that has already vested.
     */
    function _vestedAmount(address account) public view returns (uint256) {
        require(_startTimestamp != 0, "Vesting has not been started");
        uint256 totalBalance = (_sumUser[account] * _rateToken[_userToken[account]]) / (1 ether);
        if (block.timestamp < _startTimestamp) {
            return 0;
        } else if (block.timestamp >= _startTimestamp + _duration * _durationCount) {
            return totalBalance;
        } else {
            return (totalBalance * ((block.timestamp - _startTimestamp) / (_duration))) / (_durationCount);
        }
    }
}

// File: ../sc_datasets/DAppSCAN/Hacken-Bolide-V2/contracts-9ca0cf09d7707bcbd942f0000f11059c5fb9c026/private_sale/contracts/PrivateSale.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;
pragma abicoder v2;



interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function latestAnswer() external view returns (int256 answer);
}

interface IBurnable {
    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;
}

contract PrivateSale is Ownable {
    using SafeERC20 for IERC20;

    //*** Structs  ***//

    struct Round {
        mapping(address => bool) whiteList;
        mapping(address => uint256) sums;
        mapping(address => address) depositToken;
        mapping(address => uint256) tokenReserve;
        uint256 totalReserve;
        uint256 tokensSold;
        uint256 tokenRate;
        uint256 maxMoney;
        uint256 sumTokens;
        uint256 minimumSaleAmount;
        uint256 maximumSaleAmount;
        uint256 startTimestamp;
        uint256 endTimestamp;
        uint256 duration;
        uint256 durationCount;
        uint256 lockup;
        TokenVestingGroup vestingContract;
        uint8 percentOnInvestorWallet;
        uint8 typeRound;
        bool finished;
        bool open;
        bool burnable;
    }

    struct InputNewRound {
        uint256 _tokenRate;
        uint256 _maxMoney;
        uint256 _sumTokens;
        uint256 _startTimestamp;
        uint256 _endTimestamp;
        uint256 _minimumSaleAmount;
        uint256 _maximumSaleAmount;
        uint256 _duration;
        uint256 _durationCount;
        uint256 _lockup;
        uint8 _typeRound;
        uint8 _percentOnInvestorWallet;
        bool _burnable;
        bool _open;
    }

    //*** Variable ***//
    mapping(uint256 => Round) rounds;
    address investorWallet;
    uint256 countRound;
    uint256 countTokens;
    mapping(uint256 => address) tokens;
    mapping(address => address) oracles;
    mapping(address => bool) tokensAdd;

    address BLID;
    address expenseAddress;

    //*** Modifiers ***//

    modifier isUsedToken(address _token) {
        require(tokensAdd[_token], "Token is not used ");
        _;
    }

    modifier finishedRound() {
        require(countRound == 0 || rounds[countRound - 1].finished, "Last round has not been finished");
        _;
    }

    modifier unfinishedRound() {
        require(countRound != 0 && !rounds[countRound - 1].finished, "Last round has  been finished");
        _;
    }
    modifier existRound(uint256 round) {
        require(round < countRound, "Number round more than Rounds count");
        _;
    }

    /*** User function ***/

    /**
     * @notice User deposit amount of token for
     * @param amount Amount of token
     * @param token Address of token
     */
    function deposit(uint256 amount, address token) external isUsedToken(token) unfinishedRound {
        require(rounds[countRound - 1].open || rounds[countRound - 1].whiteList[msg.sender], "No access");
        require(!isParticipatedInTheRound(countRound - 1), "You  have already made a deposit");
        require(rounds[countRound - 1].startTimestamp < block.timestamp, "Round dont start");
        require(
            rounds[countRound - 1].minimumSaleAmount <=
                amount * 10**(18 - AggregatorV3Interface(token).decimals()),
            "Minimum sale amount more than your amount"
        );
        require(
            rounds[countRound - 1].maximumSaleAmount == 0 ||
                rounds[countRound - 1].maximumSaleAmount >=
                amount * 10**(18 - AggregatorV3Interface(token).decimals()),
            " Your amount more than maximum sale amount"
        );
        require(
            rounds[countRound - 1].endTimestamp > block.timestamp || rounds[countRound - 1].endTimestamp == 0,
            "Round is ended, round time expired"
        );
        require(
            rounds[countRound - 1].tokenRate == 0 ||
                rounds[countRound - 1].sumTokens == 0 ||
                rounds[countRound - 1].sumTokens >=
                ((rounds[countRound - 1].totalReserve +
                    amount *
                    10**(18 - AggregatorV3Interface(token).decimals())) * (1 ether)) /
                    rounds[countRound - 1].tokenRate,
            "Round is ended, all tokens sold"
        );
        require(
            rounds[countRound - 1].maxMoney == 0 ||
                rounds[countRound - 1].maxMoney >=
                (rounds[countRound - 1].totalReserve +
                    amount *
                    10**(18 - AggregatorV3Interface(token).decimals())),
            "The round is over, the maximum required value has been reached, or your amount is greater than specified in the conditions of the round"
        );
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        rounds[countRound - 1].tokenReserve[token] +=
            amount *
            10**(18 - AggregatorV3Interface(token).decimals());
        rounds[countRound - 1].sums[msg.sender] +=
            amount *
            10**(18 - AggregatorV3Interface(token).decimals());
        rounds[countRound - 1].depositToken[msg.sender] = token;
        rounds[countRound - 1].totalReserve += amount * 10**(18 - AggregatorV3Interface(token).decimals());
        rounds[countRound - 1].vestingContract.deposit(
            msg.sender,
            token,
            amount * 10**(18 - AggregatorV3Interface(token).decimals())
        );
    }

    /**
     * @notice User return deposit of round
     * @param round number of round
     */
    function returnDeposit(uint256 round) external {
        require(round < countRound, "Number round more than Rounds count");
        require(rounds[round].sums[msg.sender] > 0, "You don't have deposit or you return your deposit");
        require(
            !rounds[round].finished || rounds[round].typeRound == 0,
            "round has been finished successfully"
        );
        IERC20(rounds[round].depositToken[msg.sender]).safeTransfer(
            msg.sender,
            rounds[round].sums[msg.sender] /
                10**(18 - AggregatorV3Interface(rounds[round].depositToken[msg.sender]).decimals())
        );
        rounds[round].vestingContract.returnDeposit(msg.sender);
        rounds[round].totalReserve -= rounds[round].sums[msg.sender];
        rounds[round].tokenReserve[rounds[round].depositToken[msg.sender]] -= rounds[round].sums[msg.sender];
        rounds[round].sums[msg.sender] = 0;
        rounds[round].depositToken[msg.sender] = address(0);
    }

    /**
     * @notice Add token and token's oracle
     * @param _token Address of Token
     * @param _oracles Address of token's oracle(https://docs.chain.link/docs/binance-smart-chain-addresses/
     */
    function addToken(address _token, address _oracles) external onlyOwner {
        require(_token != address(0) && _oracles != address(0));
        require(!tokensAdd[_token], "token was added");
        oracles[_token] = _oracles;
        tokens[countTokens++] = _token;
        tokensAdd[_token] = true;
    }

    /**
     * @notice Set Investor Wallet
     * @param _investorWallet address of InvestorWallet
     */
    function setInvestorWallet(address _investorWallet) external onlyOwner finishedRound {
        investorWallet = _investorWallet;
    }

    /**
     * @notice Set Expense Wallet
     * @param _expenseAddress address of Expense Address
     */
    function setExpenseAddress(address _expenseAddress) external onlyOwner finishedRound {
        expenseAddress = _expenseAddress;
    }

    /**
     * @notice Set Expense Wallet and Investor Wallet
     * @param _investorWallet address of InvestorWallet
     * @param _expenseAddress address of Expense Address
     */
    function setExpenseAddressAndInvestorWallet(address _expenseAddress, address _investorWallet)
        external
        onlyOwner
        finishedRound
    {
        expenseAddress = _expenseAddress;
        investorWallet = _investorWallet;
    }

    /**
     * @notice Set blid in contract
     * @param _BLID address of BLID
     */
    function setBLID(address _BLID) external onlyOwner {
        require(BLID == address(0), "BLID was set");
        BLID = _BLID;
    }

    /**
     * @notice Creat new round with input parameters
     * @param input Data about of new round
     */
    function newRound(InputNewRound memory input) external onlyOwner finishedRound {
        require(BLID != address(0), "BLID is not set");
        require(expenseAddress != address(0), "Require set expense address ");
        require(
            investorWallet != address(0) || input._percentOnInvestorWallet == 0,
            "Require set Logic contract"
        );
        require(
            input._endTimestamp == 0 || input._endTimestamp > block.timestamp,
            "_endTimestamp must be unset or more than now timestamp"
        );
        if (input._typeRound == 1) {
            require(input._tokenRate > 0, "Need set _tokenRate and _tokenRate must be more than 0");
            require(
                IERC20(BLID).balanceOf(address(this)) >= input._sumTokens,
                "_sumTokens more than this smart contract have BLID"
            );
            require(input._sumTokens > 0, "Need set _sumTokens ");
            rounds[countRound].tokenRate = input._tokenRate;
            rounds[countRound].maxMoney = input._maxMoney;
            rounds[countRound].startTimestamp = input._startTimestamp;
            rounds[countRound].sumTokens = input._sumTokens;
            rounds[countRound].endTimestamp = input._endTimestamp;
            rounds[countRound].duration = input._duration;
            rounds[countRound].durationCount = input._durationCount;
            rounds[countRound].minimumSaleAmount = input._minimumSaleAmount;
            rounds[countRound].maximumSaleAmount = input._maximumSaleAmount;
            rounds[countRound].lockup = input._lockup;
            rounds[countRound].percentOnInvestorWallet = input._percentOnInvestorWallet;
            rounds[countRound].burnable = input._burnable;
            rounds[countRound].open = input._open;
            rounds[countRound].typeRound = input._typeRound;
            address[] memory inputTokens = new address[](countTokens);
            for (uint256 i = 0; i < countTokens; i++) {
                inputTokens[i] = tokens[i];
            }
            rounds[countRound].vestingContract = new TokenVestingGroup(
                BLID,
                input._duration,
                input._durationCount,
                inputTokens
            );
            countRound++;
        } else if (input._typeRound == 2) {
            require(input._sumTokens > 0, "Need set _sumTokens");
            require(input._tokenRate == 0, "Need unset _tokenRate (_tokenRate==0)");
            require(!input._burnable, "Need not burnable round");
            require(
                IERC20(BLID).balanceOf(address(this)) >= input._sumTokens,
                "_sumTokens more than this smart contract have BLID"
            );
            rounds[countRound].tokenRate = input._tokenRate;
            rounds[countRound].maxMoney = input._maxMoney;
            rounds[countRound].startTimestamp = input._startTimestamp;
            rounds[countRound].endTimestamp = input._endTimestamp;
            rounds[countRound].sumTokens = input._sumTokens;
            rounds[countRound].duration = input._duration;
            rounds[countRound].minimumSaleAmount = input._minimumSaleAmount;
            rounds[countRound].maximumSaleAmount = input._maximumSaleAmount;
            rounds[countRound].durationCount = input._durationCount;
            rounds[countRound].lockup = input._lockup;
            rounds[countRound].percentOnInvestorWallet = input._percentOnInvestorWallet;
            rounds[countRound].burnable = input._burnable;
            rounds[countRound].open = input._open;
            rounds[countRound].typeRound = input._typeRound;
            address[] memory inputTokens = new address[](countTokens);
            for (uint256 i = 0; i < countTokens; i++) {
                inputTokens[i] = (tokens[i]);
            }
            rounds[countRound].vestingContract = new TokenVestingGroup(
                BLID,
                input._duration,
                input._durationCount,
                inputTokens
            );
            countRound++;
        }
    }

    /**
     * @notice Set rate of token for last round(only for round that typy is 1)
     * @param rate Rate token  token/usd * 10**18
     */
    function setRateToken(uint256 rate) external onlyOwner unfinishedRound {
        require(rounds[countRound - 1].typeRound == 1, "This round auto generate rate");
        rounds[countRound - 1].tokenRate = rate;
    }

    /**
     * @notice Set timestamp when end round
     * @param _endTimestamp timesetamp when round is ended
     */
    function setEndTimestamp(uint256 _endTimestamp) external onlyOwner unfinishedRound {
        rounds[countRound - 1].endTimestamp = _endTimestamp;
    }

    /**
     * @notice Set Sum Tokens
     * @param _sumTokens Amount of selling BLID. Necessarily with the type of round 2
     */
    function setSumTokens(uint256 _sumTokens) external onlyOwner unfinishedRound {
        require(
            IERC20(BLID).balanceOf(address(this)) >= _sumTokens,
            "_sumTokens more than this smart contract have BLID"
        );
        require(_sumTokens > rounds[countRound - 1].tokensSold, "Token sold more than _sumTokens");
        rounds[countRound - 1].sumTokens = _sumTokens;
    }

    /**
     * @notice Set  Start Timestamp
     * @param _startTimestamp Unix timestamp  Start Round
     */
    function setStartTimestamp(uint256 _startTimestamp) external onlyOwner unfinishedRound {
        require(block.timestamp < _startTimestamp, "Round has been started");
        rounds[countRound - 1].startTimestamp = _startTimestamp;
    }

    /**
     * @notice Set Max Money
     * @param _maxMoney Amount USD when close round
     */
    function setMaxMoney(uint256 _maxMoney) external onlyOwner unfinishedRound {
        require(rounds[countRound - 1].totalReserve < _maxMoney, "Now total reserve more than _maxMoney");
        rounds[countRound - 1].maxMoney = _maxMoney;
    }

    /**
     * @notice Add account in white list
     * @param account Address is added in white list
     */
    function addWhiteList(address account) external onlyOwner unfinishedRound {
        rounds[countRound - 1].whiteList[account] = true;
    }

    /**
     * @notice Add accounts in white list
     * @param accounts Addresses are added in white list
     */
    function addWhiteListByArray(address[] calldata accounts) external onlyOwner unfinishedRound {
        for (uint256 i = 0; i < accounts.length; i++) {
            rounds[countRound - 1].whiteList[accounts[i]] = true;
        }
    }

    /**
     * @notice Delete accounts in white list
     * @param account Address is deleted in white list
     */
    function deleteWhiteList(address account) external onlyOwner unfinishedRound {
        rounds[countRound - 1].whiteList[account] = false;
    }

    /**
     * @notice Delete accounts in white list
     * @param accounts Addresses are  deleted in white list
     */
    function deleteWhiteListByArray(address[] calldata accounts) external onlyOwner unfinishedRound {
        for (uint256 i = 0; i < accounts.length; i++) {
            rounds[countRound - 1].whiteList[accounts[i]] = false;
        }
    }

    /**
     * @notice Finish round, send rate to VestingGroup contracts
     */
    function finishRound() external onlyOwner {
        require(countRound != 0 && !rounds[countRound - 1].finished, "Last round has been finished");
        uint256[] memory rates = new uint256[](countTokens);
        uint256 sumUSD = 0;
        for (uint256 i = 0; i < countTokens; i++) {
            if (rounds[countRound - 1].tokenReserve[tokens[i]] == 0) continue;
            IERC20(tokens[i]).safeTransfer(
                expenseAddress,
                rounds[countRound - 1].tokenReserve[tokens[i]] /
                    10**(18 - AggregatorV3Interface(tokens[i]).decimals()) -
                    ((rounds[countRound - 1].tokenReserve[tokens[i]] /
                        10**(18 - AggregatorV3Interface(tokens[i]).decimals())) *
                        (rounds[countRound - 1].percentOnInvestorWallet)) /
                    100
            );
            IERC20(tokens[i]).safeTransfer(
                investorWallet,
                ((rounds[countRound - 1].tokenReserve[tokens[i]] /
                    10**(18 - AggregatorV3Interface(tokens[i]).decimals())) *
                    (rounds[countRound - 1].percentOnInvestorWallet)) / 100
            );
            rates[i] = (uint256(AggregatorV3Interface(oracles[tokens[i]]).latestAnswer()) *
                10**(18 - AggregatorV3Interface(oracles[tokens[i]]).decimals()));

            sumUSD += (rounds[countRound - 1].tokenReserve[tokens[i]] * rates[i]) / (1 ether);
            if (rounds[countRound - 1].typeRound == 1)
                rates[i] = (rates[i] * (1 ether)) / rounds[countRound - 1].tokenRate;
            if (rounds[countRound - 1].typeRound == 2)
                rates[i] = (rounds[countRound - 1].sumTokens * rates[i]) / sumUSD;
        }
        if (sumUSD != 0) {
            rounds[countRound - 1].vestingContract.finishRound(
                block.timestamp + rounds[countRound - 1].lockup,
                rates
            );
            if (rounds[countRound - 1].typeRound == 1)
                IERC20(BLID).safeTransfer(
                    address(rounds[countRound - 1].vestingContract),
                    (sumUSD * (1 ether)) / rounds[countRound - 1].tokenRate
                );
        }
        if (rounds[countRound - 1].typeRound == 2)
            IERC20(BLID).safeTransfer(
                address(rounds[countRound - 1].vestingContract),
                rounds[countRound - 1].sumTokens
            );
        if (
            rounds[countRound - 1].burnable &&
            rounds[countRound - 1].sumTokens - (sumUSD * (1 ether)) / rounds[countRound - 1].tokenRate != 0
        ) {
            IBurnable(BLID).burn(
                rounds[countRound - 1].sumTokens - (sumUSD * (1 ether)) / rounds[countRound - 1].tokenRate
            );
        }
        rounds[countRound - 1].finished = true;
    }

    /**
     * @notice Cancel round
     */
    function cancelRound() external onlyOwner {
        require(countRound != 0 && !rounds[countRound - 1].finished, "Last round has been finished");
        rounds[countRound - 1].finished = true;
        rounds[countRound - 1].typeRound = 0;
    }

    /**
     * @param id Number of round
     * @return InputNewRound - information about round
     */
    function getRoundStateInfromation(uint256 id) public view returns (InputNewRound memory) {
        InputNewRound memory out = InputNewRound(
            rounds[id].tokenRate,
            rounds[id].maxMoney,
            rounds[id].sumTokens,
            rounds[id].startTimestamp,
            rounds[id].endTimestamp,
            rounds[id].minimumSaleAmount,
            rounds[id].maximumSaleAmount,
            rounds[id].duration,
            rounds[id].durationCount,
            rounds[id].lockup,
            rounds[id].typeRound,
            rounds[id].percentOnInvestorWallet,
            rounds[id].burnable,
            rounds[id].open
        );
        return out;
    }

    /**
     * @param id Number of round
     * @return  Locked Tokens
     */
    function getLockedTokens(uint256 id) public view returns (uint256) {
        if (rounds[id].tokenRate == 0) return 0;
        return ((rounds[id].totalReserve * (1 ether)) / rounds[id].tokenRate);
    }

    /**
     * @param id Number of round
     * @return  Returns (all deposited money, sold tokens, open or close round)
     */
    function getRoundDynamicInfromation(uint256 id)
        public
        view
        returns (
            uint256,
            uint256,
            bool
        )
    {
        if (rounds[id].typeRound == 1) {
            return (rounds[id].totalReserve, rounds[id].totalReserve / rounds[id].tokenRate, rounds[id].open);
        } else {
            return (rounds[id].totalReserve, rounds[id].sumTokens, rounds[id].open);
        }
    }

    /**
     * @return  True if `account`  is in white list
     */
    function isInWhiteList(address account) public view returns (bool) {
        return rounds[countRound - 1].whiteList[account];
    }

    /**
     * @return  Count round
     */
    function getCountRound() public view returns (uint256) {
        return countRound;
    }

    /**
     * @param id Number of round
     * @return  Address Vesting contract
     */
    function getVestingAddress(uint256 id) public view existRound(id) returns (address) {
        return address(rounds[id].vestingContract);
    }

    /**
     * @param id Number of round
     * @param account Address of depositor
     * @return  Investor Deposited Tokens
     */
    function getInvestorDepositedTokens(uint256 id, address account)
        public
        view
        existRound(id)
        returns (uint256)
    {
        return (rounds[id].sums[account]);
    }

    /**
     * @return  Investor Deposited Tokens
     */
    function getInvestorWallet() public view returns (address) {
        return investorWallet;
    }

    /**
     * @param id Number of round
     * @return   True if `id` round is cancelled
     */
    function isCancelled(uint256 id) public view existRound(id) returns (bool) {
        return rounds[id].typeRound == 0;
    }

    /**
     * @param id Number of round
     * @return True if `msg.sender`  is Participated In The Round
     */
    function isParticipatedInTheRound(uint256 id) public view existRound(id) returns (bool) {
        return rounds[id].depositToken[msg.sender] != address(0);
    }

    /**
     * @param id Number of round
     * @return Deposited token addres of `msg.sender`
     */
    function getUserToken(uint256 id) public view existRound(id) returns (address) {
        return rounds[id].depositToken[msg.sender];
    }

    /**
     * @param id Number of round
     * @return True if `id` round  is finished
     */
    function isFinished(uint256 id) public view returns (bool) {
        return rounds[id].finished;
    }
}
