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

// File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20Upgradeable {
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

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IAgToken.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title IAgToken
/// @author Angle Core Team
/// @notice Interface for the stablecoins `AgToken` contracts
/// @dev This interface only contains functions of the `AgToken` contract which are called by other contracts
/// of this module or of the first module of the Angle Protocol
interface IAgToken is IERC20Upgradeable {
    // ======================= Minter Role Only Functions ===========================

    /// @notice Lets the `StableMaster` contract or another whitelisted contract mint agTokens
    /// @param account Address to mint to
    /// @param amount Amount to mint
    /// @dev The contracts allowed to issue agTokens are the `StableMaster` contract, `VaultManager` contracts
    /// associated to this stablecoin as well as the flash loan module (if activated) and potentially contracts
    /// whitelisted by governance
    function mint(address account, uint256 amount) external;

    /// @notice Burns `amount` tokens from a `burner` address after being asked to by `sender`
    /// @param amount Amount of tokens to burn
    /// @param burner Address to burn from
    /// @param sender Address which requested the burn from `burner`
    /// @dev This method is to be called by a contract with the minter right after being requested
    /// to do so by a `sender` address willing to burn tokens from another `burner` address
    /// @dev The method checks the allowance between the `sender` and the `burner`
    function burnFrom(
        uint256 amount,
        address burner,
        address sender
    ) external;

    /// @notice Burns `amount` tokens from a `burner` address
    /// @param amount Amount of tokens to burn
    /// @param burner Address to burn from
    /// @dev This method is to be called by a contract with a minter right on the AgToken after being
    /// requested to do so by an address willing to burn tokens from its address
    function burnSelf(uint256 amount, address burner) external;

    // ========================= Treasury Only Functions ===========================

    /// @notice Adds a minter in the contract
    /// @param minter Minter address to add
    /// @dev Zero address checks are performed directly in the `Treasury` contract
    function addMinter(address minter) external;

    /// @notice Removes a minter from the contract
    /// @param minter Minter address to remove
    /// @dev This function can also be called by a minter wishing to revoke itself
    function removeMinter(address minter) external;

    /// @notice Sets a new treasury contract
    /// @param _treasury New treasury address
    function setTreasury(address _treasury) external;

    // ========================= External functions ================================

    /// @notice Checks whether an address has the right to mint agTokens
    /// @param minter Address for which the minting right should be checked
    /// @return Whether the address has the right to mint agTokens or not
    function isMinter(address minter) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/ISwapper.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title ISwapper
/// @author Angle Core Team
/// @notice Interface for Swapper contracts
/// @dev This interface defines the key functions `Swapper` contracts should have when interacting with
/// Angle
interface ISwapper {
    /// @notice Notifies a contract that an address should be given `outToken` from `inToken`
    /// @param inToken Address of the token received
    /// @param outToken Address of the token to obtain
    /// @param outTokenRecipient Address to which the outToken should be sent
    /// @param outTokenOwed Minimum amount of outToken the `outTokenRecipient` address should have at the end of the call
    /// @param inTokenObtained Amount of collateral obtained by a related address prior
    /// to the call to this function
    /// @param data Extra data needed (to encode Uniswap swaps for instance)
    function swap(
        IERC20 inToken,
        IERC20 outToken,
        address outTokenRecipient,
        uint256 outTokenOwed,
        uint256 inTokenObtained,
        bytes calldata data
    ) external;
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: @openzeppelin/contracts/interfaces/IERC721Metadata.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC721Metadata.sol)

pragma solidity ^0.8.0;

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/ICoreBorrow.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title ICoreBorrow
/// @author Angle Core Team
/// @notice Interface for the `CoreBorrow` contract
/// @dev This interface only contains functions of the `CoreBorrow` contract which are called by other contracts
/// of this module
interface ICoreBorrow {
    /// @notice Checks if an address corresponds to a treasury of a stablecoin with a flash loan
    /// module initialized on it
    /// @param treasury Address to check
    /// @return Whether the address has the `FLASHLOANER_TREASURY_ROLE` or not
    function isFlashLoanerTreasury(address treasury) external view returns (bool);

    /// @notice Checks whether an address is governor of the Angle Protocol or not
    /// @param admin Address to check
    /// @return Whether the address has the `GOVERNOR_ROLE` or not
    function isGovernor(address admin) external view returns (bool);

    /// @notice Checks whether an address is governor or a guardian of the Angle Protocol or not
    /// @param admin Address to check
    /// @return Whether the address has the `GUARDIAN_ROLE` or not
    /// @dev Governance should make sure when adding a governor to also give this governor the guardian
    /// role by calling the `addGovernor` function
    function isGovernorOrGuardian(address admin) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IFlashAngle.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;


/// @title IFlashAngle
/// @author Angle Core Team
/// @notice Interface for the `FlashAngle` contract
/// @dev This interface only contains functions of the contract which are called by other contracts
/// of this module
interface IFlashAngle {
    /// @notice Reference to the `CoreBorrow` contract managing the FlashLoan module
    function core() external view returns (ICoreBorrow);

    /// @notice Sends the fees taken from flash loans to the treasury contract associated to the stablecoin
    /// @param stablecoin Stablecoin from which profits should be sent
    /// @return balance Amount of profits sent
    /// @dev This function can only be called by the treasury contract
    function accrueInterestToTreasury(IAgToken stablecoin) external returns (uint256 balance);

    /// @notice Adds support for a stablecoin
    /// @param _treasury Treasury associated to the stablecoin to add support for
    /// @dev This function can only be called by the `CoreBorrow` contract
    function addStablecoinSupport(address _treasury) external;

    /// @notice Removes support for a stablecoin
    /// @param _treasury Treasury associated to the stablecoin to remove support for
    /// @dev This function can only be called by the `CoreBorrow` contract
    function removeStablecoinSupport(address _treasury) external;

    /// @notice Sets a new core contract
    /// @param _core Core contract address to set
    /// @dev This function can only be called by the `CoreBorrow` contract
    function setCore(address _core) external;
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/ITreasury.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;



/// @title ITreasury
/// @author Angle Core Team
/// @notice Interface for the `Treasury` contract
/// @dev This interface only contains functions of the `Treasury` which are called by other contracts
/// of this module
interface ITreasury {
    /// @notice Stablecoin handled by this `treasury` contract
    function stablecoin() external view returns (IAgToken);

    /// @notice Checks whether a given address has the  governor role
    /// @param admin Address to check
    /// @return Whether the address has the governor role
    /// @dev Access control is only kept in the `CoreBorrow` contract
    function isGovernor(address admin) external view returns (bool);

    /// @notice Checks whether a given address has the guardian or the governor role
    /// @param admin Address to check
    /// @return Whether the address has the guardian or the governor role
    /// @dev Access control is only kept in the `CoreBorrow` contract which means that this function
    /// queries the `CoreBorrow` contract
    function isGovernorOrGuardian(address admin) external view returns (bool);

    /// @notice Checks whether a given address has well been initialized in this contract
    /// as a `VaultManager``
    /// @param _vaultManager Address to check
    /// @return Whether the address has been initialized or not
    function isVaultManager(address _vaultManager) external view returns (bool);

    /// @notice Sets a new flash loan module for this stablecoin
    /// @param _flashLoanModule Reference to the new flash loan module
    /// @dev This function removes the minting right to the old flash loan module and grants
    /// it to the new module
    function setFlashLoanModule(address _flashLoanModule) external;
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

/// @title IOracle
/// @author Angle Core Team
/// @notice Interface for the `Oracle` contract
/// @dev This interface only contains functions of the contract which are called by other contracts
/// of this module
interface IOracle {
    /// @notice Reads the rate from the Chainlink circuit and other data provided
    /// @return quoteAmount The current rate between the in-currency and out-currency in the base
    /// of the out currency
    /// @dev For instance if the out currency is EUR (and hence agEUR), then the base of the returned
    /// value is 10**18
    function read() external view returns (uint256);

    /// @notice Changes the treasury contract
    /// @param _treasury Address of the new treasury contract
    /// @dev This function can be called by an approved `VaultManager` contract which can call
    /// this function after being requested to do so by a `treasury` contract
    /// @dev In some situations (like reactor contracts), the `VaultManager` may not directly be linked
    /// to the `oracle` contract and as such we may need governors to be able to call this function as well
    function setTreasury(address _treasury) external;

    /// @notice Reference to the `treasury` contract handling this `VaultManager`
    function treasury() external view returns (ITreasury treasury);
}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/interfaces/IVaultManager.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;




// ========================= Key Structs and Enums =============================

/// @notice Parameters associated to a given `VaultManager` contract: these all correspond
/// to parameters which signification is detailed in the `VaultManagerStorage` file
struct VaultParameters {
    uint256 debtCeiling;
    uint64 collateralFactor;
    uint64 targetHealthFactor;
    uint64 interestRate;
    uint64 liquidationSurcharge;
    uint64 maxLiquidationDiscount;
    bool whitelistingActivated;
    uint256 baseBoost;
}

/// @notice Data stored to track someone's loan (or equivalently called position)
struct Vault {
    // Amount of collateral deposited in the vault, in collateral decimals. For example, if the collateral
    // is USDC with 6 decimals, then `collateralAmount` will be in base 10**6
    uint256 collateralAmount;
    // Normalized value of the debt (that is to say of the stablecoins borrowed). It is expressed
    // in the base of Angle stablecoins (i.e. `BASE_TOKENS = 10**18`)
    uint256 normalizedDebt;
}

/// @notice For a given `vaultID`, this encodes a liquidation opportunity that is to say details about the maximum
/// amount that could be repaid by liquidating the position
/// @dev All the values are null in the case of a vault which cannot be liquidated under these conditions
struct LiquidationOpportunity {
    // Maximum stablecoin amount that can be repaid upon liquidating the vault
    uint256 maxStablecoinAmountToRepay;
    // Collateral amount given to the person in the case where the maximum amount to repay is given
    uint256 maxCollateralAmountGiven;
    // Threshold value of stablecoin amount to repay: it is ok for a liquidator to repay below threshold,
    // but if this threshold is non null and the liquidator wants to repay more than threshold, it should repay
    // the max stablecoin amount given in this vault
    uint256 thresholdRepayAmount;
    // Discount proposed to the liquidator on the collateral
    uint256 discount;
    // Amount of debt in the vault
    uint256 currentDebt;
}

/// @notice Data stored during a liquidation process to keep in memory what's due to a liquidator and some
/// essential data for vaults being liquidated
struct LiquidatorData {
    // Current amount of stablecoins the liquidator should give to the contract
    uint256 stablecoinAmountToReceive;
    // Current amount of collateral the contract should give to the liquidator
    uint256 collateralAmountToGive;
    // Bad debt accrued across the liquidation process
    uint256 badDebtFromLiquidation;
    // Oracle value (in stablecoin base) at the time of the liquidation
    uint256 oracleValue;
    // Value of the `interestAccumulator` at the time of the call
    uint256 newInterestAccumulator;
}

/// @notice Data to track during a series of action the amount to give or receive in stablecoins and collateral
/// to the caller or associated addresses
struct PaymentData {
    // Stablecoin amount the contract should give
    uint256 stablecoinAmountToGive;
    // Stablecoin amount owed to the contract
    uint256 stablecoinAmountToReceive;
    // Collateral amount the contract should give
    uint256 collateralAmountToGive;
    // Collateral amount owed to the contract
    uint256 collateralAmountToReceive;
}

/// @notice Actions possible when composing calls to the different entry functions proposed
enum ActionType {
    createVault,
    closeVault,
    addCollateral,
    removeCollateral,
    repayDebt,
    borrow,
    getDebtIn,
    permit
}

// ========================= Interfaces =============================

/// @title IVaultManagerFunctions
/// @author Angle Core Team
/// @notice Interface for the `VaultManager` contract
/// @dev This interface only contains functions of the contract which are called by other contracts
/// of this module (without getters)
interface IVaultManagerFunctions {
    /// @notice Accrues interest accumulated across all vaults to the surplus and sends the surplus to the treasury
    /// @return surplusValue Value of the surplus communicated to the `Treasury`
    /// @return badDebtValue Value of the bad debt communicated to the `Treasury`
    /// @dev `surplus` and `badDebt` should be reset to 0 once their current value have been given to the `treasury` contract
    function accrueInterestToTreasury() external returns (uint256 surplusValue, uint256 badDebtValue);

    /// @notice Removes debt from a vault after being requested to do so by another `VaultManager` contract
    /// @param vaultID ID of the vault to remove debt from
    /// @param amountStablecoins Amount of stablecoins to remove from the debt: this amount is to be converted to an
    /// internal debt amount
    /// @param senderBorrowFee Borrowing fees from the contract which requested this: this is to make sure that people are not
    /// arbitraging difference in minting fees
    /// @param senderRepayFee Repay fees from the contract which requested this: this is to make sure that people are not arbitraging
    /// differences in repay fees
    /// @dev This function can only be called from a vaultManager registered in the same Treasury
    function getDebtOut(
        uint256 vaultID,
        uint256 amountStablecoins,
        uint256 senderBorrowFee,
        uint256 senderRepayFee
    ) external;

    /// @notice Gets the current debt of a vault
    /// @param vaultID ID of the vault to check
    /// @return Debt of the vault
    function getVaultDebt(uint256 vaultID) external view returns (uint256);

    /// @notice Gets the total debt across all vaults
    /// @return Total debt across all vaults, taking into account the interest accumulated
    /// over time
    function getTotalDebt() external view returns (uint256);

    /// @notice Sets the treasury contract
    /// @param _treasury New treasury contract
    /// @dev All required checks when setting up a treasury contract are performed in the contract
    /// calling this function
    function setTreasury(address _treasury) external;

    /// @notice Creates a vault
    /// @param toVault Address for which the va
    /// @return vaultID ID of the vault created
    /// @dev This function just creates the vault without doing any collateral or
    function createVault(address toVault) external returns (uint256);

    /// @notice Allows composability between calls to the different entry points of this module. Any user calling
    /// this function can perform any of the allowed actions in the order of their choice
    /// @param actions Set of actions to perform
    /// @param datas Data to be decoded for each action: it can include like the `vaultID` or the `stablecoinAmount` to borrow
    /// @param from Address from which stablecoins will be taken if one action includes burning stablecoins. This address
    /// should either be the `msg.sender` or be approved by the latter
    /// @param to Address to which stablecoins and/or collateral will be sent in case of
    /// @param who Address of the contract to handle in case of repayment of stablecoins from received collateral
    /// @param repayData Data to pass to the repayment contract in case of
    /// @return paymentData Struct containing the accounting changes from the protocol's perspective (like how much of collateral
    /// or how much has been received). Note that the values in the struct are not aggregated and you could have in the output
    /// a positive amount of stablecoins to receive as well as a positive amount of stablecoins to give
    /// @dev This function is optimized to reduce gas cost due to payment from or to the user and that expensive calls
    /// or computations (like `oracleValue`) are done only once
    /// @dev When specifying `vaultID` in `data`, it is important to know that if you specify `vaultID = 0`, it will simply
    /// use the latest `vaultID`. This is the default behavior, and unless you're engaging into some complex protocol actions
    /// it is encouraged to use `vaultID = 0` only when the first action of the batch is `createVault`
    function angle(
        ActionType[] memory actions,
        bytes[] memory datas,
        address from,
        address to,
        address who,
        bytes memory repayData
    ) external returns (PaymentData memory paymentData);

    /// @notice This function is a wrapper built on top of the function above. It enables users to interact with the contract
    /// without having to provide `who` and `repayData` parameters
    function angle(
        ActionType[] memory actions,
        bytes[] memory datas,
        address from,
        address to
    ) external returns (PaymentData memory paymentData);

    /// @notice Initializes the `VaultManager` contract
    /// @param _treasury Treasury address handling the contract
    /// @param _collateral Collateral supported by this contract
    /// @param _oracle Oracle contract used
    /// @param _symbol Symbol used to define the `VaultManager` name and symbol
    /// @dev The parameters and the oracle are the only elements which could be modified once the
    /// contract has been initialized
    /// @dev For the contract to be fully initialized, governance needs to set the parameters for the liquidation
    /// boost
    function initialize(
        ITreasury _treasury,
        IERC20 _collateral,
        IOracle _oracle,
        VaultParameters calldata params,
        string memory _symbol
    ) external;
}

/// @title IVaultManagerStorage
/// @author Angle Core Team
/// @notice Interface for the `VaultManager` contract
/// @dev This interface contains getters of the contract's public variables used by other contracts
/// of this module
interface IVaultManagerStorage {
    /// @notice Minimum amount of debt a vault can have, expressed in `BASE_TOKENS` that is to say the base of the agTokens
    function dust() external view returns (uint256);

    /// @notice Encodes the maximum ratio stablecoin/collateral a vault can have before being liquidated. It's what
    /// determines the minimum collateral ratio of a position
    function collateralFactor() external view returns (uint64);

    /// @notice Stablecoin handled by this contract. Another `VaultManager` contract could have
    /// the same rights as this `VaultManager` on the stablecoin contract
    function stablecoin() external view returns (IAgToken);

    /// @notice Reference to the `treasury` contract handling this `VaultManager`
    function treasury() external view returns (ITreasury);

    /// @notice Oracle contract to get access to the price of the collateral with respect to the stablecoin
    function oracle() external view returns (IOracle);

    /// @notice The `interestAccumulator` variable keeps track of the interest that should accrue to the protocol.
    /// The stored value is not necessarily the true value: this one is recomputed every time an action takes place
    /// within the protocol. It is in base `BASE_INTEREST`
    function interestAccumulator() external view returns (uint256);

    /// @notice Reference to the collateral handled by this `VaultManager`
    function collateral() external view returns (IERC20);

    /// @notice Total normalized amount of stablecoins borrowed, not taking into account the potential bad debt accumulated
    /// This value is expressed in the base of Angle stablecoins (`BASE_TOKENS = 10**18`)
    function totalNormalizedDebt() external view returns (uint256);

    /// @notice Maximum amount of stablecoins that can be issued with this contract. It is expressed in `BASE_TOKENS`
    function debtCeiling() external view returns (uint256);

    /// @notice Maps a `vaultID` to its data (namely collateral amount and normalized debt)
    function vaultData(uint256 vaultID) external view returns (uint256 collateralAmount, uint256 normalizedDebt);

    /// @notice ID of the last vault created. The `vaultIDCount` variables serves as a counter to generate a unique
    /// `vaultID` for each vault: it is like `tokenID` in basic ERC721 contracts
    function vaultIDCount() external view returns (uint256);
}

/// @title IVaultManager
/// @author Angle Core Team
/// @notice Interface for the `VaultManager` contract
interface IVaultManager is IVaultManagerFunctions, IVaultManagerStorage, IERC721Metadata {

}

// File: ../sc_datasets/DAppSCAN/Chainsecurity-Angle Protocol  Borrowing Module/angle-borrow-0363b6a137a44e22ee06b3187ba74f7798c1af08/contracts/settlement/Settlement.sol

// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;





/// @title Settlement
/// @author Angle Core Team
/// @notice Settlement Contract for a VaultManager
/// @dev This settlement contract should be activated by a careful governance which needs to have performed
/// some key operations before activating this contract
/// @dev In case of global settlement, there should be one settlement contract per `VaultManager`
contract Settlement {
    using SafeERC20 for IERC20;

    /// @notice Base used for parameter computation
    uint256 public constant BASE_PARAMS = 10**9;
    /// @notice Base used for interest computation
    uint256 public constant BASE_INTEREST = 10**27;
    /// @notice Base used for exchange rate computation. It is assumed
    /// that stablecoins have this base
    uint256 public constant BASE_STABLECOIN = 10**18;
    /// @notice Duration of the claim period for over-collateralized vaults
    uint256 public constant OVER_COLLATERALIZED_CLAIM_DURATION = 3 * 24 * 3600;

    // =============== Immutable references set in the constructor =================

    /// @notice `VaultManager` of this settlement contract
    IVaultManager public immutable vaultManager;
    /// @notice Reference to the stablecoin supported by the `VaultManager` contract
    IAgToken public immutable stablecoin;
    /// @notice Reference to the collateral supported by the `VaultManager`
    IERC20 public immutable collateral;
    /// @notice Base of the collateral
    uint256 internal immutable _collatBase;

    // ================ Variables frozen at settlement activation ==================

    /// @notice Value of the oracle for the collateral/stablecoin pair
    uint256 public oracleValue;
    /// @notice Value of the interest accumulator at settlement activation
    uint256 public interestAccumulator;
    /// @notice Timestamp at which settlement was activated
    uint256 public activationTimestamp;
    /// @notice Collateral factor of the `VaultManager`
    uint64 public collateralFactor;

    // =================== Variables updated during the process ====================

    /// @notice How much collateral you can get from stablecoins
    uint256 public collateralStablecoinExchangeRate;
    /// @notice Amount of collateral that will be left over at the end of the process
    uint256 public leftOverCollateral;
    /// @notice Whether the `collateralStablecoinExchangeRate` has been computed
    bool public exchangeRateComputed;
    /// @notice Maps a vault to 1 if it was claimed by its owner
    mapping(uint256 => uint256) public vaultCheck;

    // ================================ Events =====================================

    event GlobalClaimPeriodActivated(uint256 _collateralStablecoinExchangeRate);
    event Recovered(address indexed tokenAddress, address indexed to, uint256 amount);
    event SettlementActivated(uint256 startTimestamp);
    event VaultClaimed(uint256 vaultID, uint256 stablecoinAmount, uint256 collateralAmount);

    // ================================ Errors =====================================

    error GlobalClaimPeriodNotStarted();
    error InsolventVault();
    error NotGovernor();
    error NotOwner();
    error RestrictedClaimPeriodNotEnded();
    error SettlementNotInitialized();
    error VaultAlreadyClaimed();

    /// @notice Constructor of the contract
    /// @param _vaultManager Address of the `VaultManager` associated to this `Settlement` contract
    /// @dev Out of safety, this constructor reads values from the `VaultManager` contract directly
    constructor(IVaultManager _vaultManager) {
        vaultManager = _vaultManager;
        stablecoin = _vaultManager.stablecoin();
        collateral = _vaultManager.collateral();
        _collatBase = 10**(IERC20Metadata(address(collateral)).decimals());
    }

    /// @notice Checks whether the `msg.sender` has the governor role or not
    modifier onlyGovernor() {
        if (!(vaultManager.treasury().isGovernor(msg.sender))) revert NotGovernor();
        _;
    }

    /// @notice Activates the settlement contract
    /// @dev When calling this function governance should make sure to have:
    /// 1. Accrued the interest rate on the contract
    /// 2. Paused the contract
    /// 3. Recovered all the collateral available in the `VaultManager` contract either
    /// by doing a contract upgrade or by calling a `recoverERC20` method if supported
    function activateSettlement() external onlyGovernor {
        oracleValue = (vaultManager.oracle()).read();
        interestAccumulator = vaultManager.interestAccumulator();
        activationTimestamp = block.timestamp;
        collateralFactor = vaultManager.collateralFactor();
        emit SettlementActivated(block.timestamp);
    }

    /// @notice Allows the owner of an over-collateralized vault to claim its collateral upon bringing back all owed stablecoins
    /// @param vaultID ID of the vault to claim
    /// @param to Address to which collateral should be sent
    /// @param who Address which should be notified if needed of the transfer of stablecoins and collateral
    /// @param data Data to pass to the `who` contract for it to successfully give the correct amount of stablecoins
    /// to the `msg.sender` address
    /// @return Amount of collateral sent to the `to` address
    /// @return Amount of stablecoins sent to the contract
    /// @dev Claiming can only happen short after settlement activation
    /// @dev A vault cannot be claimed twice and only the owner of the vault can claim it (regardless of the approval logic)
    /// @dev Only over-collateralized vaults can be claimed from this medium
    function claimOverCollateralizedVault(
        uint256 vaultID,
        address to,
        address who,
        bytes memory data
    ) external returns (uint256, uint256) {
        if (activationTimestamp == 0 || block.timestamp > activationTimestamp + OVER_COLLATERALIZED_CLAIM_DURATION)
            revert SettlementNotInitialized();
        if (vaultCheck[vaultID] == 1) revert VaultAlreadyClaimed();
        if (vaultManager.ownerOf(vaultID) != msg.sender) revert NotOwner();
        (uint256 collateralAmount, uint256 normalizedDebt) = vaultManager.vaultData(vaultID);
        uint256 vaultDebt = (normalizedDebt * interestAccumulator) / BASE_INTEREST;
        if (collateralAmount * oracleValue * collateralFactor < vaultDebt * BASE_PARAMS * _collatBase)
            revert InsolventVault();
        vaultCheck[vaultID] = 1;
        emit VaultClaimed(vaultID, vaultDebt, collateralAmount);
        return _handleRepay(collateralAmount, vaultDebt, to, who, data);
    }

    /// @notice Activates the global claim period by setting the `collateralStablecoinExchangeRate` which is going to
    /// dictate how much of collateral will be recoverable for each stablecoin
    /// @dev This function can only be called by the governor in order to allow it in case multiple settlements happen across
    /// different `VaultManager` to rebalance the amount of stablecoins on each to make sure that across all settlement contracts
    /// a similar value of collateral can be obtained against a similar value of stablecoins
    function activateGlobalClaimPeriod() external onlyGovernor {
        if (activationTimestamp == 0 || block.timestamp <= activationTimestamp + OVER_COLLATERALIZED_CLAIM_DURATION)
            revert RestrictedClaimPeriodNotEnded();
        uint256 collateralBalance = collateral.balanceOf(address(this));
        uint256 leftOverDebt = (vaultManager.totalNormalizedDebt() * interestAccumulator) / BASE_INTEREST;
        uint256 stablecoinBalance = stablecoin.balanceOf(address(this));
        // How much 1 of stablecoin will give you in collateral
        uint256 _collateralStablecoinExchangeRate;

        if (stablecoinBalance < leftOverDebt) {
            // The left over debt is the total debt minus the stablecoins which have already been accumulated
            // in the first phase
            leftOverDebt -= stablecoinBalance;
            // If you control all the debt, then you are entitled to get all the collateral left in the protocol
            _collateralStablecoinExchangeRate = (collateralBalance * BASE_STABLECOIN) / leftOverDebt;
            // But at the same time, you cannot get more collateral than the value of the stablecoins you brought
            uint256 maxExchangeRate = (BASE_STABLECOIN * _collatBase) / oracleValue;
            if (_collateralStablecoinExchangeRate >= maxExchangeRate) {
                // In this situation, we're sure that `leftOverCollateral` will be positive: governance should be wary
                // to call `recoverERC20` short after though as there's nothing that is going to prevent people to redeem
                // more stablecoins than the `leftOverDebt`
                leftOverCollateral = collateralBalance - (leftOverDebt * _collatBase) / oracleValue;
                _collateralStablecoinExchangeRate = maxExchangeRate;
            }
        }
        exchangeRateComputed = true;
        // In the else case where there is no debt left, you cannot get anything from your stablecoins
        // and so the `collateralStablecoinExchangeRate` is null
        collateralStablecoinExchangeRate = _collateralStablecoinExchangeRate;
        emit GlobalClaimPeriodActivated(_collateralStablecoinExchangeRate);
    }

    /// @notice Allows to claim collateral from stablecoins
    /// @param to Address to which collateral should be sent
    /// @param who Address which should be notified if needed of the transfer of stablecoins and collateral
    /// @param data Data to pass to the `who` contract for it to successfully give the correct amount of stablecoins
    /// to the `msg.sender` address
    /// @return Amount of collateral sent to the `to` address
    /// @return Amount of stablecoins sent to the contract
    /// @dev This function reverts if the `collateralStablecoinExchangeRate` is null and hence if the global claim period has
    /// not been activated
    function claimCollateralFromStablecoins(
        uint256 stablecoinAmount,
        address to,
        address who,
        bytes memory data
    ) external returns (uint256, uint256) {
        if (!exchangeRateComputed) revert GlobalClaimPeriodNotStarted();
        return
            _handleRepay(
                (stablecoinAmount * collateralStablecoinExchangeRate) / BASE_STABLECOIN,
                stablecoinAmount,
                to,
                who,
                data
            );
    }

    /// @notice Handles the simultaneous repayment of stablecoins with a transfer of collateral
    /// @param collateralAmountToGive Amount of collateral the contract should give
    /// @param stableAmountToRepay Amount of stablecoins the contract should burn from the call
    /// @param to Address to which stablecoins should be sent
    /// @param who Address which should be notified if needed of the transfer
    /// @param data Data to pass to the `who` contract for it to successfully give the correct amount of stablecoins
    /// to the `msg.sender` address
    /// @dev This function allows for capital-efficient claims of collateral from stablecoins
    function _handleRepay(
        uint256 collateralAmountToGive,
        uint256 stableAmountToRepay,
        address to,
        address who,
        bytes memory data
    ) internal returns (uint256, uint256) {
        collateral.safeTransfer(to, collateralAmountToGive);
        if (data.length > 0) {
            ISwapper(who).swap(
                collateral,
                IERC20(address(stablecoin)),
                msg.sender,
                stableAmountToRepay,
                collateralAmountToGive,
                data
            );
        }
        stablecoin.transferFrom(msg.sender, address(this), stableAmountToRepay);
        return (collateralAmountToGive, stableAmountToRepay);
    }

    /// @notice Recovers leftover tokens from the contract or tokens that were mistakenly sent to the contract
    /// @param tokenAddress Address of the token to recover
    /// @param to Address to send the remaining tokens to
    /// @param amountToRecover Amount to recover from the contract
    /// @dev Governors cannot recover more collateral than what would be leftover from the contract
    /// @dev This function can be used to rebalance stablecoin balances across different settlement contracts
    /// to make sure every stablecoin can be redeemed for the same value of collateral
    /// @dev It can also be used to recover tokens that are mistakenly sent to this contract
    function recoverERC20(
        address tokenAddress,
        address to,
        uint256 amountToRecover
    ) external onlyGovernor {
        if (tokenAddress == address(collateral)) {
            if (!exchangeRateComputed) revert GlobalClaimPeriodNotStarted();
            leftOverCollateral -= amountToRecover;
            collateral.safeTransfer(to, amountToRecover);
        } else {
            IERC20(tokenAddress).safeTransfer(to, amountToRecover);
        }
        emit Recovered(tokenAddress, to, amountToRecover);
    }
}
