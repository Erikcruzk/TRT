// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Connext NXTP — Noncustodial Xchain Transfer Protocol/nxtp-0656436d654cfe0313fa3c2bbc81aa86232ade16/packages/contracts/contracts/interfaces/IFulfillInterpreter.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

interface IFulfillInterpreter {

  event Executed(
    bytes32 indexed transactionId,
    address payable callTo,
    address assetId,
    address payable fallbackAddress,
    uint256 amount,
    bytes callData,
    bytes returnData,
    bool success
  );

  function getTransactionManager() external returns (address);

  function execute(
    bytes32 transactionId,
    address payable callTo,
    address assetId,
    address payable fallbackAddress,
    uint256 amount,
    bytes calldata callData
  ) external payable returns (bool success, bytes memory returnData);
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Connext NXTP — Noncustodial Xchain Transfer Protocol/nxtp-0656436d654cfe0313fa3c2bbc81aa86232ade16/packages/contracts/contracts/interfaces/ITransactionManager.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

interface ITransactionManager {
  // Structs

  // Holds all data that is constant between sending and
  // receiving chains. The hash of this is what gets signed
  // to ensure the signature can be used on both chains.
  struct InvariantTransactionData {
    address receivingChainTxManagerAddress;
    address user;
    address router;
    address sendingAssetId;
    address receivingAssetId;
    address sendingChainFallback; // funds sent here on cancel
    address receivingAddress;
    address callTo;
    uint256 sendingChainId;
    uint256 receivingChainId;
    bytes32 callDataHash; // hashed to prevent free option
    bytes32 transactionId;
  }

  // Holds all data that varies between sending and receiving
  // chains. The hash of this is stored onchain to ensure the
  // information passed in is valid.
  struct VariantTransactionData {
    uint256 amount;
    uint256 expiry;
    uint256 preparedBlockNumber;
  }

  // All Transaction data, constant and variable
  struct TransactionData {
    address receivingChainTxManagerAddress;
    address user;
    address router;
    address sendingAssetId;
    address receivingAssetId;
    address sendingChainFallback;
    address receivingAddress;
    address callTo;
    bytes32 callDataHash;
    bytes32 transactionId;
    uint256 sendingChainId;
    uint256 receivingChainId;
    uint256 amount;
    uint256 expiry;
    uint256 preparedBlockNumber; // Needed for removal of active blocks on fulfill/cancel
  }

  // The structure of the signed data for fulfill
  struct SignedFulfillData {
    bytes32 transactionId;
    uint256 relayerFee;
    string functionIdentifier; // "fulfill" or "cancel"
    uint256 receivingChainId; // For domain separation
    address receivingChainTxManagerAddress; // For domain separation
  }

  // The structure of the signed data for cancellation
  struct SignedCancelData {
    bytes32 transactionId;
    string functionIdentifier;
    uint256 receivingChainId;
    address receivingChainTxManagerAddress; // For domain separation
  }

  // Adding/removing asset events
  event RouterAdded(address indexed addedRouter, address indexed caller);

  event RouterRemoved(address indexed removedRouter, address indexed caller);

  // Adding/removing router events
  event AssetAdded(address indexed addedAssetId, address indexed caller);

  event AssetRemoved(address indexed removedAssetId, address indexed caller);

  // Liquidity events
  event LiquidityAdded(address indexed router, address indexed assetId, uint256 amount, address caller);

  event LiquidityRemoved(address indexed router, address indexed assetId, uint256 amount, address recipient);

  // Transaction events
  event TransactionPrepared(
    address indexed user,
    address indexed router,
    bytes32 indexed transactionId,
    TransactionData txData,
    address caller,
    bytes encryptedCallData,
    bytes encodedBid,
    bytes bidSignature
  );

  event TransactionFulfilled(
    address indexed user,
    address indexed router,
    bytes32 indexed transactionId,
    TransactionData txData,
    uint256 relayerFee,
    bytes signature,
    bytes callData,
    bool success,
    bytes returnData,
    address caller
  );

  event TransactionCancelled(
    address indexed user,
    address indexed router,
    bytes32 indexed transactionId,
    TransactionData txData,
    address caller
  );

  // Getters
  function getChainId() external view returns (uint256);

  function getStoredChainId() external view returns (uint256);

  // Owner only methods
  function addRouter(address router) external;

  function removeRouter(address router) external;

  function addAssetId(address assetId) external;

  function removeAssetId(address assetId) external;

  // Router only methods
  function addLiquidityFor(uint256 amount, address assetId, address router) external payable;

  function addLiquidity(uint256 amount, address assetId) external payable;

  function removeLiquidity(
    uint256 amount,
    address assetId,
    address payable recipient
  ) external;

  // Methods for crosschain transfers
  // called in the following order (in happy case)
  // 1. prepare by user on sending chain
  // 2. prepare by router on receiving chain
  // 3. fulfill by user on receiving chain
  // 4. fulfill by router on sending chain
  function prepare(
    InvariantTransactionData calldata txData,
    uint256 amount,
    uint256 expiry,
    bytes calldata encryptedCallData,
    bytes calldata encodedBid,
    bytes calldata bidSignature
  ) external payable returns (TransactionData memory);

  function fulfill(
    TransactionData calldata txData,
    uint256 relayerFee,
    bytes calldata signature,
    bytes calldata callData
  ) external returns (TransactionData memory);

  function cancel(TransactionData calldata txData, bytes calldata signature) external returns (TransactionData memory);
}

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

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Connext NXTP — Noncustodial Xchain Transfer Protocol/nxtp-0656436d654cfe0313fa3c2bbc81aa86232ade16/packages/contracts/contracts/lib/LibAsset.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;


/**
* @title LibAsset
* @author Connext <support@connext.network>
* @notice This library contains helpers for dealing with onchain transfers
*         of assets, including accounting for the native asset `assetId`
*         conventions and any noncompliant ERC20 transfers
*/
library LibAsset {
  /** 
  * @dev All native assets use the empty address for their asset id
  *      by convention
  */
  address constant NATIVE_ASSETID = address(0);

  /** 
  * @notice Determines whether the given assetId is the native asset
  * @param assetId The asset identifier to evaluate
  * @return Boolean indicating if the asset is the native asset
  */
  function isNativeAsset(address assetId) internal pure returns (bool) {
    return assetId == NATIVE_ASSETID;
  }

  /** 
  * @notice Gets the balance of the inheriting contract for the given asset
  * @param assetId The asset identifier to get the balance of
  * @return Balance held by contracts using this library
  */
  function getOwnBalance(address assetId) internal view returns (uint256) {
    return
      isNativeAsset(assetId)
        ? address(this).balance
        : IERC20(assetId).balanceOf(address(this));
  }

  /** 
  * @notice Transfers ether from the inheriting contract to a given
  *         recipient
  * @param recipient Address to send ether to
  * @param amount Amount to send to given recipient
  */
  function transferNativeAsset(address payable recipient, uint256 amount)
      internal
  {
    (bool success,) = recipient.call{value: amount}("");
    require(success, "#TNA:028");
  }

  /** 
  * @notice Transfers tokens from the inheriting contract to a given
  *         recipient
  * @param assetId Token address to transfer
  * @param recipient Address to send ether to
  * @param amount Amount to send to given recipient
  */
  function transferERC20(
      address assetId,
      address recipient,
      uint256 amount
  ) internal {
    SafeERC20.safeTransfer(IERC20(assetId), recipient, amount);
  }

  /** 
  * @notice Transfers tokens from a sender to a given recipient
  * @param assetId Token address to transfer
  * @param from Address of sender/owner
  * @param to Address of recipient/spender
  * @param amount Amount to transfer from owner to spender
  */
  function transferFromERC20(
    address assetId,
    address from,
    address to,
    uint256 amount
  ) internal {
    SafeERC20.safeTransferFrom(IERC20(assetId), from, to, amount);
  }

  /** 
  * @notice Increases the allowance of a token to a spender
  * @param assetId Token address of asset to increase allowance of
  * @param spender Account whos allowance is increased
  * @param amount Amount to increase allowance by
  */
  function increaseERC20Allowance(
    address assetId,
    address spender,
    uint256 amount
  ) internal {
    require(!isNativeAsset(assetId), "#IA:034");
    SafeERC20.safeIncreaseAllowance(IERC20(assetId), spender, amount);
  }

  /**
  * @notice Decreases the allowance of a token to a spender
  * @param assetId Token address of asset to decrease allowance of
  * @param spender Account whos allowance is decreased
  * @param amount Amount to decrease allowance by
  */
  function decreaseERC20Allowance(
    address assetId,
    address spender,
    uint256 amount
  ) internal {
    require(!isNativeAsset(assetId), "#DA:034");
    SafeERC20.safeDecreaseAllowance(IERC20(assetId), spender, amount);
  }

  /**
  * @notice Wrapper function to transfer a given asset (native or erc20) to
  *         some recipient. Should handle all non-compliant return value
  *         tokens as well by using the SafeERC20 contract by open zeppelin.
  * @param assetId Asset id for transfer (address(0) for native asset, 
  *                token address for erc20s)
  * @param recipient Address to send asset to
  * @param amount Amount to send to given recipient
  */
  function transferAsset(
      address assetId,
      address payable recipient,
      uint256 amount
  ) internal {
    isNativeAsset(assetId)
      ? transferNativeAsset(recipient, amount)
      : transferERC20(assetId, recipient, amount);
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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Connext NXTP — Noncustodial Xchain Transfer Protocol/nxtp-0656436d654cfe0313fa3c2bbc81aa86232ade16/packages/contracts/contracts/interpreters/FulfillInterpreter.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;





/**
  * @title FulfillInterpreter
  * @author Connext <support@connext.network>
  * @notice This library contains an `execute` function that is callabale by
  *         an associated TransactionManager contract. This is used to execute
  *         arbitrary calldata on a receiving chain.
  */
contract FulfillInterpreter is ReentrancyGuard, IFulfillInterpreter {
  address private immutable _transactionManager;

  constructor(address transactionManager) {
    _transactionManager = transactionManager;
  }

  /**
  * @notice Errors if the sender is not the transaction manager
  */
  modifier onlyTransactionManager {
    require(msg.sender == _transactionManager, "#OTM:027");
    _;
  }

  /** 
    * @notice Returns the transaction manager address (only address that can 
    *         call the `execute` function)
    * @return The address of the associated transaction manager
    */
  function getTransactionManager() override external view returns (address) {
    return _transactionManager;
  }

  /** 
    * @notice Executes some arbitrary call data on a given address. The
    *         call data executes can be payable, and will have `amount` sent
    *         along with the function (or approved to the contract). If the
    *         call fails, rather than reverting, funds are sent directly to 
    *         some provided fallbaack address
    * @param transactionId Unique identifier of transaction id that necessitated
    *        calldata execution
    * @param callTo The address to execute the calldata on
    * @param assetId The assetId of the funds to approve to the contract or
    *                send along with the call
    * @param fallbackAddress The address to send funds to if the `call` fails
    * @param amount The amount to approve or send with the call
    * @param callData The data to execute
    */
  function execute(
    bytes32 transactionId,
    address payable callTo,
    address assetId,
    address payable fallbackAddress,
    uint256 amount,
    bytes calldata callData
  ) override external payable onlyTransactionManager returns (bool, bytes memory) {
    // If it is not ether, approve the callTo
    // We approve here rather than transfer since many external contracts
    // simply require an approval, and it is unclear if they can handle 
    // funds transferred directly to them (i.e. Uniswap)
    bool isNative = LibAsset.isNativeAsset(assetId);
    if (!isNative) {
      LibAsset.increaseERC20Allowance(assetId, callTo, amount);
    }

    // Check if the callTo is a contract
    bool success;
    bytes memory returnData;
    if (Address.isContract(callTo)) {
      // Try to execute the callData
      // the low level call will return `false` if its execution reverts
      (success, returnData) = callTo.call{value: isNative ? amount : 0}(callData);
    }

    // Handle failure cases
    if (!success) {
      // If it fails, transfer to fallback
      LibAsset.transferAsset(assetId, fallbackAddress, amount);
      // Decrease allowance
      if (!isNative) {
        LibAsset.decreaseERC20Allowance(assetId, callTo, amount);
      }
    }

    // Emit event
    emit Executed(
      transactionId,
      callTo,
      assetId,
      fallbackAddress,
      amount,
      callData,
      returnData,
      success
    );
    return (success, returnData);
  }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Connext NXTP — Noncustodial Xchain Transfer Protocol/nxtp-0656436d654cfe0313fa3c2bbc81aa86232ade16/packages/contracts/contracts/ProposedOwnable.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

/**
 * @title ProposedOwnable
 * @notice Contract module which provides a basic access control mechanism, 
 * where there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed via a two step process:
 * 1. Call `proposeOwner`
 * 2. Wait out the delay period
 * 3. Call `acceptOwner`
 *
 * @dev This module is used through inheritance. It will make available the 
 * modifier `onlyOwner`, which can be applied to your functions to restrict 
 * their use to the owner.
 * 
 * @dev The majority of this code was taken from the openzeppelin Ownable 
 * contract
 *
 */
abstract contract ProposedOwnable {
  address private _owner;

  address private _proposed;
  uint256 private _proposedOwnershipTimestamp;

  bool private _routerOwnershipRenounced;
  uint256 private _routerOwnershipTimestamp;

  bool private _assetOwnershipRenounced;
  uint256 private _assetOwnershipTimestamp;

  uint256 private constant _delay = 7 days;

  event RouterOwnershipRenunciationProposed(uint256 timestamp);

  event RouterOwnershipRenounced(bool renounced);

  event AssetOwnershipRenunciationProposed(uint256 timestamp);

  event AssetOwnershipRenounced(bool renounced);

  event OwnershipProposed(address indexed proposedOwner);

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
    * @notice Initializes the contract setting the deployer as the initial 
    * owner.
    */
  constructor() {
    _setOwner(msg.sender);
  }

  /**
    * @notice Returns the address of the current owner.
    */
  function owner() public view virtual returns (address) {
    return _owner;
  }

  /**
    * @notice Returns the address of the proposed owner.
    */
  function proposed() public view virtual returns (address) {
    return _proposed;
  }

  /**
    * @notice Returns the address of the proposed owner.
    */
  function proposedTimestamp() public view virtual returns (uint256) {
    return _proposedOwnershipTimestamp;
  }

  /**
    * @notice Returns the timestamp when router ownership was last proposed to be renounced
    */
  function routerOwnershipTimestamp() public view virtual returns (uint256) {
    return _routerOwnershipTimestamp;
  }

  /**
    * @notice Returns the timestamp when asset ownership was last proposed to be renounced
    */
  function assetOwnershipTimestamp() public view virtual returns (uint256) {
    return _assetOwnershipTimestamp;
  }

  /**
    * @notice Returns the delay period before a new owner can be accepted.
    */
  function delay() public view virtual returns (uint256) {
    return _delay;
  }

  /**
    * @notice Throws if called by any account other than the owner.
    */
  modifier onlyOwner() {
      require(_owner == msg.sender, "#OO:029");
      _;
  }

  /**
    * @notice Throws if called by any account other than the proposed owner.
    */
  modifier onlyProposed() {
      require(_proposed == msg.sender, "#OP:035");
      _;
  }

  /** 
    * @notice Indicates if the ownership of the router whitelist has
    * been renounced
    */
  function isRouterOwnershipRenounced() public view returns (bool) {
    return _owner == address(0) || _routerOwnershipRenounced;
  }

  /** 
    * @notice Indicates if the ownership of the router whitelist has
    * been renounced
    */
  function proposeRouterOwnershipRenunciation() public virtual onlyOwner {
    // Use contract as source of truth
    // Will fail if all ownership is renounced by modifier
    require(!_routerOwnershipRenounced, "#PROR:038");

    // Begin delay, emit event
    _setRouterOwnershipTimestamp();
  }

  /** 
    * @notice Indicates if the ownership of the asset whitelist has
    * been renounced
    */
  function renounceRouterOwnership() public virtual onlyOwner {
    // Contract as sournce of truth
    // Will fail if all ownership is renounced by modifier
    require(!_routerOwnershipRenounced, "#RRO:038");

    // Ensure there has been a proposal cycle started
    require(_routerOwnershipTimestamp > 0, "#RRO:037");

    // Delay has elapsed
    require((block.timestamp - _routerOwnershipTimestamp) > _delay, "#RRO:030");

    // Set renounced, emit event, reset timestamp to 0
    _setRouterOwnership(true);
  }

  /** 
    * @notice Indicates if the ownership of the asset whitelist has
    * been renounced
    */
  function isAssetOwnershipRenounced() public view returns (bool) {
    return _owner == address(0) || _assetOwnershipRenounced;
  }

  /** 
    * @notice Indicates if the ownership of the asset whitelist has
    * been renounced
    */
  function proposeAssetOwnershipRenunciation() public virtual onlyOwner {
    // Contract as sournce of truth
    // Will fail if all ownership is renounced by modifier
    require(!_assetOwnershipRenounced, "#PAOR:038");

    // Start cycle, emit event
    _setAssetOwnershipTimestamp();
  }

  /** 
    * @notice Indicates if the ownership of the asset whitelist has
    * been renounced
    */
  function renounceAssetOwnership() public virtual onlyOwner {
    // Contract as sournce of truth
    // Will fail if all ownership is renounced by modifier
    require(!_assetOwnershipRenounced, "#RAO:038");

    // Ensure there has been a proposal cycle started
    require(_assetOwnershipTimestamp > 0, "#RAO:037");

    // Ensure delay has elapsed
    require((block.timestamp - _assetOwnershipTimestamp) > _delay, "#RAO:030");

    // Set ownership, reset timestamp, emit event
    _setAssetOwnership(true);
  }

  /** 
    * @notice Indicates if the ownership has been renounced() by
    * checking if current owner is address(0)
    */
  function renounced() public view returns (bool) {
    return _owner == address(0);
  }

  /**
    * @notice Sets the timestamp for an owner to be proposed, and sets the
    * newly proposed owner as step 1 in a 2-step process
   */
  function proposeNewOwner(address newlyProposed) public virtual onlyOwner {
    // Contract as source of truth
    require(_proposed != newlyProposed || newlyProposed == address(0), "#PNO:036");

    // Sanity check: reasonable proposal
    require(_owner != newlyProposed, "#PNO:038");

    _setProposed(newlyProposed);
  }

  /**
    * @notice Renounces ownership of the contract after a delay
    */
  function renounceOwnership() public virtual onlyOwner {
    // Ensure there has been a proposal cycle started
    require(_proposedOwnershipTimestamp > 0, "#RO:037");

    // Ensure delay has elapsed
    require((block.timestamp - _proposedOwnershipTimestamp) > _delay, "#RO:030");

    // Require proposed is set to 0
    require(_proposed == address(0), "#RO:036");

    // Emit event, set new owner, reset timestamp
    _setOwner(_proposed);
  }

  /**
    * @notice Transfers ownership of the contract to a new account (`newOwner`).
    * Can only be called by the current owner.
    */
  function acceptProposedOwner() public virtual onlyProposed {
    // Contract as source of truth
    require(_owner != _proposed, "#APO:038");

    // NOTE: no need to check if _proposedOwnershipTimestamp > 0 because
    // the only time this would happen is if the _proposed was never
    // set (will fail from modifier) or if the owner == _proposed (checked
    // above)

    // Ensure delay has elapsed
    require((block.timestamp - _proposedOwnershipTimestamp) > _delay, "#APO:030");

    // Emit event, set new owner, reset timestamp
    _setOwner(_proposed);
  }

  ////// INTERNAL //////

  function _setRouterOwnershipTimestamp() private {
    _routerOwnershipTimestamp = block.timestamp;
    emit RouterOwnershipRenunciationProposed(_routerOwnershipTimestamp);
  }

  function _setRouterOwnership(bool value) private {
    _routerOwnershipRenounced = value;
    _routerOwnershipTimestamp = 0;
    emit RouterOwnershipRenounced(value);
  }

  function _setAssetOwnershipTimestamp() private {
    _assetOwnershipTimestamp = block.timestamp;
    emit AssetOwnershipRenunciationProposed(_assetOwnershipTimestamp);
  }

  function _setAssetOwnership(bool value) private {
    _assetOwnershipRenounced = value;
    _assetOwnershipTimestamp = 0;
    emit AssetOwnershipRenounced(value);
  }

  function _setOwner(address newOwner) private {
    address oldOwner = _owner;
    _owner = newOwner;
    _proposedOwnershipTimestamp = 0;
    emit OwnershipTransferred(oldOwner, newOwner);
  }

  function _setProposed(address newlyProposed) private {
    _proposedOwnershipTimestamp = block.timestamp;
    _proposed = newlyProposed;
    emit OwnershipProposed(_proposed);
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

// File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)

pragma solidity ^0.8.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSA {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV // Deprecated in v4.8
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature` or error string. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     *
     * Documentation for signature generation:
     * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
     * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            /// @solidity memory-safe-assembly
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
     *
     * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
        bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
        uint8 v = uint8((uint256(vs) >> 255) + 27);
        return tryRecover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
     *
     * _Available since v4.2._
     */
    function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
     * `r` and `s` signature fields separately.
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, "\x19Ethereum Signed Message:\n32")
            mstore(0x1c, hash)
            message := keccak256(0x00, 0x3c)
        }
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from `s`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {recover}.
     */
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, "\x19\x01")
            mstore(add(ptr, 0x02), domainSeparator)
            mstore(add(ptr, 0x22), structHash)
            data := keccak256(ptr, 0x42)
        }
    }

    /**
     * @dev Returns an Ethereum Signed Data with intended validator, created from a
     * `validator` and `data` according to the version 0 of EIP-191.
     *
     * See {recover}.
     */
    function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x00", validator, data));
    }
}

// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Connext NXTP — Noncustodial Xchain Transfer Protocol/nxtp-0656436d654cfe0313fa3c2bbc81aa86232ade16/packages/contracts/contracts/TransactionManager.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;








/**
  *
  * @title TransactionManager
  * @author Connext <support@connext.network>
  * @notice This contract holds the logic to facilitate crosschain transactions.
  *         Transactions go through three phases in the happy case:
  *
  *         1. Route Auction (offchain): User broadcasts to our network 
  *         signalling their desired route. Routers respond with sealed bids 
  *         containing commitments to fulfilling the transaction within a 
  *         certain time and price range.
  *
  *         2. Prepare: Once the auction is completed, the transaction can be 
  *         prepared. The user submits a transaction to `TransactionManager` 
  *         contract on sender-side chain containing router's signed bid. This 
  *         transaction locks up the users funds on the sending chain. Upon 
  *         detecting an event containing their signed bid from the chain, 
  *         router submits the same transaction to `TransactionManager` on the 
  *         receiver-side chain, and locks up a corresponding amount of 
  *         liquidity. The amount locked on the receiving chain is `sending 
  *         amount - auction fee` so the router is incentivized to complete the 
  *         transaction.
  *
  *         3. Fulfill: Upon detecting the `TransactionPrepared` event on the 
  *         receiver-side chain, the user signs a message and sends it to a 
  *         relayer, who will earn a fee for submission. The relayer (which may 
  *         be the router) then submits the message to the `TransactionManager` 
  *         to complete their transaction on receiver-side chain and claim the 
  *         funds locked by the router. A relayer is used here to allow users 
  *         to submit transactions with arbitrary calldata on the receiving 
  *         chain without needing gas to do so. The router then submits the 
  *         same signed message and completes transaction on sender-side, 
  *         unlocking the original `amount`.
  *
  *         If a transaction is not fulfilled within a fixed timeout, it 
  *         reverts and can be reclaimed by the party that called `prepare` on 
  *         each chain (initiator). Additionally, transactions can be cancelled 
  *         unilaterally by the person owed funds on that chain (router for 
  *         sending chain, user for receiving chain) prior to expiry.
  */
contract TransactionManager is ReentrancyGuard, ProposedOwnable, ITransactionManager {
  /**
   * @dev Mapping of router to balance specific to asset
   */
  mapping(address => mapping(address => uint256)) public routerBalances;

  /**
    * @dev Mapping of allowed router addresses. Must be added to both
    *      sending and receiving chains when forwarding a transfer.
    */
  mapping(address => bool) public approvedRouters;

  /**
    * @dev Mapping of allowed assetIds on same chain as contract
    */
  mapping(address => bool) public approvedAssets;

  /**
    * @dev Mapping of hash of `InvariantTransactionData` to the hash
    *      of the `VariantTransactionData`
    */
  mapping(bytes32 => bytes32) public variantTransactionData;

  /**
  * @dev The stored chain id of the contract, may be passed in to avoid any 
  *      evm issues
  */
  uint256 private immutable chainId;

  /**
    * @dev Minimum timeout (will be the lowest on the receiving chain)
    */
  uint256 public constant MIN_TIMEOUT = 1 days; // 24 hours

  /**
    * @dev Maximum timeout (will be the highest on the sending chain)
    */
  uint256 public constant MAX_TIMEOUT = 30 days; // 720 hours

  /**
    * @dev The external contract that will execute crosschain
    *      calldata
    */
  IFulfillInterpreter public immutable interpreter;

  constructor(uint256 _chainId) {
    chainId = _chainId;
    interpreter = new FulfillInterpreter(address(this));
  }

  /** 
   * @notice Gets the chainId for this contract. If not specified during init
   *         will use the block.chainId
   */
  function getChainId() public view override returns (uint256 _chainId) {
    // Hold in memory to reduce sload calls
    uint256 chain = chainId;
    if (chain == 0) {
      // If not provided, pull from block
      assembly {
        _chainId := chainid()
      }
    } else {
      // Use provided override
      _chainId = chain;
    }
  }

  /**
   * @notice Allows us to get the chainId that this contract has stored
   */
  function getStoredChainId() external view override returns (uint256) {
    return chainId;
  }

  /**
    * @notice Used to add routers that can transact crosschain
    * @param router Router address to add
    */
  function addRouter(address router) external override onlyOwner {
    // Sanity check: not empty
    require(router != address(0), "#AR:001");

    // Sanity check: needs approval
    require(approvedRouters[router] == false, "#AR:032");

    // Update mapping
    approvedRouters[router] = true;

    // Emit event
    emit RouterAdded(router, msg.sender);
  }

  /**
    * @notice Used to remove routers that can transact crosschain
    * @param router Router address to remove
    */
  function removeRouter(address router) external override onlyOwner {
    // Sanity check: not empty
    require(router != address(0), "#RR:001");

    // Sanity check: needs removal
    require(approvedRouters[router] == true, "#RR:033");

    // Update mapping
    approvedRouters[router] = false;

    // Emit event
    emit RouterRemoved(router, msg.sender);
  }

  /**
    * @notice Used to add assets on same chain as contract that can
    *         be transferred.
    * @param assetId AssetId to add
    */
  function addAssetId(address assetId) external override onlyOwner {
    // Sanity check: needs approval
    require(approvedAssets[assetId] == false, "#AA:032");

    // Update mapping
    approvedAssets[assetId] = true;

    // Emit event
    emit AssetAdded(assetId, msg.sender);
  }

  /**
    * @notice Used to remove assets on same chain as contract that can
    *         be transferred.
    * @param assetId AssetId to remove
    */
  function removeAssetId(address assetId) external override onlyOwner {
    // Sanity check: already approval
    require(approvedAssets[assetId] == true, "#RA:033");

    // Update mapping
    approvedAssets[assetId] = false;

    // Emit event
    emit AssetRemoved(assetId, msg.sender);
  }

  /**
    * @notice This is used by anyone to increase a router's available
    *         liquidity for a given asset.
    * @param amount The amount of liquidity to add for the router
    * @param assetId The address (or `address(0)` if native asset) of the
    *                asset you're adding liquidity for
    * @param router The router you are adding liquidity on behalf of
    */
  function addLiquidityFor(uint256 amount, address assetId, address router) external payable override nonReentrant {
    _addLiquidityForRouter(amount, assetId, router);
  }

  /**
    * @notice This is used by any router to increase their available
    *         liquidity for a given asset.
    * @param amount The amount of liquidity to add for the router
    * @param assetId The address (or `address(0)` if native asset) of the
    *                asset you're adding liquidity for
    */
  function addLiquidity(uint256 amount, address assetId) external payable override nonReentrant {
    _addLiquidityForRouter(amount, assetId, msg.sender);
  }

  /**
    * @notice This is used by any router to decrease their available
    *         liquidity for a given asset.
    * @param amount The amount of liquidity to remove for the router
    * @param assetId The address (or `address(0)` if native asset) of the
    *                asset you're removing liquidity for
    * @param recipient The address that will receive the liquidity being removed
    */
    // SWC-Reentrancy: L229 - L254
  function removeLiquidity(
    uint256 amount,
    address assetId,
    address payable recipient
  ) external override nonReentrant {
    // Sanity check: recipient is sensible
    require(recipient != address(0), "#RL:007");

    // Sanity check: nonzero amounts
    require(amount > 0, "#RL:002");

    uint256 routerBalance = routerBalances[msg.sender][assetId];
    // Sanity check: amount can be deducted for the router
    require(routerBalance >= amount, "#RL:008");

    // Update router balances
    unchecked {
      routerBalances[msg.sender][assetId] = routerBalance - amount;
    }

    // Transfer from contract to specified recipient
    LibAsset.transferAsset(assetId, recipient, amount);

    // Emit event
    emit LiquidityRemoved(msg.sender, assetId, amount, recipient);
  }

  /**
    * @notice This function creates a crosschain transaction. When called on
    *         the sending chain, the user is expected to lock up funds. When
    *         called on the receiving chain, the router deducts the transfer
    *         amount from the available liquidity. The majority of the
    *         information about a given transfer does not change between chains,
    *         with three notable exceptions: `amount`, `expiry`, and 
    *         `preparedBlock`. The `amount` and `expiry` are decremented
    *         between sending and receiving chains to provide an incentive for 
    *         the router to complete the transaction and time for the router to
    *         fulfill the transaction on the sending chain after the unlocking
    *         signature is revealed, respectively.
    * @param invariantData The data for a crosschain transaction that will
    *                      not change between sending and receiving chains.
    *                      The hash of this data is used as the key to store 
    *                      the inforamtion that does change between chains 
    *                      (amount,expiry,preparedBlock) for verification
    * @param amount The amount of the transaction on this chain
    * @param expiry The block.timestamp when the transaction will no longer be
    *               fulfillable and is freely cancellable on this chain
    * @param encryptedCallData The calldata to be executed when the tx is
    *                          fulfilled. Used in the function to allow the user
    *                          to reconstruct the tx from events. Hash is stored
    *                          onchain to prevent shenanigans.
    * @param encodedBid The encoded bid that was accepted by the user for this
    *                   crosschain transfer. It is supplied as a param to the
    *                   function but is only used in event emission
    * @param bidSignature The signature of the bidder on the encoded bid for
    *                     this transaction. Only used within the function for
    *                     event emission. The validity of the bid and
    *                     bidSignature are enforced offchain
    */
  function prepare(
    InvariantTransactionData calldata invariantData,
    uint256 amount,
    uint256 expiry,
    bytes calldata encryptedCallData,
    bytes calldata encodedBid,
    bytes calldata bidSignature
  ) external payable override nonReentrant returns (TransactionData memory) {
    // Sanity check: user is sensible
    require(invariantData.user != address(0), "#P:009");

    // Sanity check: router is sensible
    require(invariantData.router != address(0), "#P:001");

    // Router is approved *on both chains*
    require(isRouterOwnershipRenounced() || approvedRouters[invariantData.router], "#P:003");

    // Sanity check: sendingChainFallback is sensible
    require(invariantData.sendingChainFallback != address(0), "#P:010");

    // Sanity check: valid fallback
    require(invariantData.receivingAddress != address(0), "#P:026");

    // Make sure the chains are different
    require(invariantData.sendingChainId != invariantData.receivingChainId, "#P:011");

    // Make sure the chains are relevant
    uint256 _chainId = getChainId();
    require(invariantData.sendingChainId == _chainId || invariantData.receivingChainId == _chainId, "#P:012");

    { // Expiry scope
      // Make sure the expiry is greater than min
      uint256 buffer = expiry - block.timestamp;
      require(buffer >= MIN_TIMEOUT, "#P:013");

      // Make sure the expiry is lower than max
      require(buffer <= MAX_TIMEOUT, "#P:014");
    }

    // Make sure the hash is not a duplicate
    bytes32 digest = keccak256(abi.encode(invariantData));
    require(variantTransactionData[digest] == bytes32(0), "#P:015");

    // NOTE: the `encodedBid` and `bidSignature` are simply passed through
    //       to the contract emitted event to ensure the availability of
    //       this information. Their validity is asserted offchain, and
    //       is out of scope of this contract. They are used as inputs so
    //       in the event of a router or user crash, they may recover the
    //       correct bid information without requiring an offchain store.

    // First determine if this is sender side or receiver side
    if (invariantData.sendingChainId == _chainId) {
      // Sanity check: amount is sensible
      // Only check on sending chain to enforce router fees. Transactions could
      // be 0-valued on receiving chain if it is just a value-less call to some
      // `IFulfillHelper`
      require(amount > 0, "#P:002");

      // Assets are approved
      // NOTE: Cannot check this on receiving chain because of differing
      // chain contexts
      require(isAssetOwnershipRenounced() || approvedAssets[invariantData.sendingAssetId], "#P:004");

      // This is sender side prepare. The user is beginning the process of 
      // submitting an onchain tx after accepting some bid. They should
      // lock their funds in the contract for the router to claim after
      // they have revealed their signature on the receiving chain via
      // submitting a corresponding `fulfill` tx

      // Validate correct amounts on msg and transfer from user to
      // contract
      amount = transferAssetToContract(invariantData.sendingAssetId, amount);

      // Store the transaction variants. This happens after transferring to
      // account for fee on transfer tokens
      variantTransactionData[digest] = hashVariantTransactionData(amount, expiry, block.number);
    } else {
      // This is receiver side prepare. The router has proposed a bid on the
      // transfer which the user has accepted. They can now lock up their
      // own liquidity on th receiving chain, which the user can unlock by
      // calling `fulfill`. When creating the `amount` and `expiry` on the
      // receiving chain, the router should have decremented both. The
      // expiry should be decremented to ensure the router has time to
      // complete the sender-side transaction after the user completes the
      // receiver-side transactoin. The amount should be decremented to act as
      // a fee to incentivize the router to complete the transaction properly.

      // Check that the callTo is a contract
      // NOTE: This cannot happen on the sending chain (different chain 
      // contexts), so a user could mistakenly create a transfer that must be
      // cancelled if this is incorrect
      require(invariantData.callTo == address(0) || Address.isContract(invariantData.callTo), "#P:031");

      // Check that the asset is approved
      // NOTE: This cannot happen on both chains because of differing chain 
      // contexts. May be possible for user to create transaction that is not
      // prepare-able on the receiver chain.
      require(isAssetOwnershipRenounced() || approvedAssets[invariantData.receivingAssetId], "#P:004");

      // Check that the caller is the router
      require(msg.sender == invariantData.router, "#P:016");

      // Check that the router isnt accidentally locking funds in the contract
      require(msg.value == 0, "#P:017");

      // Check that router has liquidity
      uint256 balance = routerBalances[invariantData.router][invariantData.receivingAssetId];
      require(balance >= amount, "#P:018");

      // Store the transaction variants
      variantTransactionData[digest] = hashVariantTransactionData(amount, expiry, block.number);

      // Decrement the router liquidity
      // using unchecked because underflow protected against with require
      unchecked {
        routerBalances[invariantData.router][invariantData.receivingAssetId] = balance - amount;
      }
    }

    // Emit event
    TransactionData memory txData = TransactionData({
      receivingChainTxManagerAddress: invariantData.receivingChainTxManagerAddress,
      user: invariantData.user,
      router: invariantData.router,
      sendingAssetId: invariantData.sendingAssetId,
      receivingAssetId: invariantData.receivingAssetId,
      sendingChainFallback: invariantData.sendingChainFallback,
      callTo: invariantData.callTo,
      receivingAddress: invariantData.receivingAddress,
      callDataHash: invariantData.callDataHash,
      transactionId: invariantData.transactionId,
      sendingChainId: invariantData.sendingChainId,
      receivingChainId: invariantData.receivingChainId,
      amount: amount,
      expiry: expiry,
      preparedBlockNumber: block.number
    });
    emit TransactionPrepared(txData.user, txData.router, txData.transactionId, txData, msg.sender, encryptedCallData, encodedBid, bidSignature);
    return txData;
  }



    /**
    * @notice This function completes a crosschain transaction. When called on
    *         the receiving chain, the user reveals their signature on the
    *         transactionId and is sent the amount corresponding to the number
    *         of shares the router locked when calling `prepare`. The router 
    *         then uses this signature to unlock the corresponding funds on the 
    *         receiving chain, which are then added back to their available 
    *         liquidity. The user includes a relayer fee since it is not 
    *         assumed they will have gas on the receiving chain. This function 
    *         *must* be called before the transaction expiry has elapsed.
    * @param txData All of the data (invariant and variant) for a crosschain
    *               transaction. The variant data provided is checked against
    *               what was stored when the `prepare` function was called.
    * @param relayerFee The fee that should go to the relayer when they are
    *                   calling the function on the receiving chain for the user
    * @param signature The users signature on the transaction id + fee that
    *                  can be used by the router to unlock the transaction on 
    *                  the sending chain
    * @param callData The calldata to be sent to and executed by the 
    *                 `FulfillHelper`
    */
  function fulfill(
    TransactionData calldata txData,
    uint256 relayerFee,
    bytes calldata signature, // signature on fee + digest
    bytes calldata callData
  ) external override nonReentrant returns (TransactionData memory) {
    // Get the hash of the invariant tx data. This hash is the same
    // between sending and receiving chains. The variant data is stored
    // in the contract when `prepare` is called within the mapping.

    { // scope: validation and effects
      bytes32 digest = hashInvariantTransactionData(txData);

      // Make sure that the variant data matches what was stored
      require(variantTransactionData[digest] == hashVariantTransactionData(txData.amount, txData.expiry, txData.preparedBlockNumber), "#F:019");

      // Make sure the expiry has not elapsed
      require(txData.expiry >= block.timestamp, "#F:020");

      // Make sure the transaction wasn't already completed
      require(txData.preparedBlockNumber > 0, "#F:021");

      // Validate the user has signed
      require(recoverFulfillSignature(txData.transactionId, relayerFee, txData.receivingChainId, txData.receivingChainTxManagerAddress, signature) == txData.user, "#F:022");

      // Sanity check: fee <= amount. Allow `=` in case of only wanting to execute
      // 0-value crosschain tx, so only providing the fee amount
      require(relayerFee <= txData.amount, "#F:023");

      // Check provided callData matches stored hash
      require(keccak256(callData) == txData.callDataHash, "#F:024");

      // To prevent `fulfill` / `cancel` from being called multiple times, the
      // preparedBlockNumber is set to 0 before being hashed. The value of the
      // mapping is explicitly *not* zeroed out so users who come online without
      // a store can tell the difference between a transaction that has not been
      // prepared, and a transaction that was already completed on the receiver
      // chain.
      variantTransactionData[digest] = hashVariantTransactionData(txData.amount, txData.expiry, 0);
    }

    // Declare these variables for the event emission. Are only assigned
    // IFF there is an external call on the receiving chain
    bool success;
    bytes memory returnData;

    if (txData.sendingChainId == getChainId()) {
      // The router is completing the transaction, they should get the
      // amount that the user deposited credited to their liquidity
      // reserves.

      // Make sure that the user is not accidentally fulfilling the transaction
      // on the sending chain
      require(msg.sender == txData.router, "#F:016");

      // Complete tx to router for original sending amount
      routerBalances[txData.router][txData.sendingAssetId] += txData.amount;

    } else {
      (success, returnData) = _receivingChainFulfill(txData, relayerFee, callData);
    }

    // Emit event
    emit TransactionFulfilled(
      txData.user,
      txData.router,
      txData.transactionId,
      txData,
      relayerFee,
      signature,
      callData,
      success,
      returnData,
      msg.sender
    );

    return txData;
  }

  /**
    * @notice Any crosschain transaction can be cancelled after it has been
    *         created to prevent indefinite lock up of funds. After the
    *         transaction has expired, anyone can cancel it. Before the
    *         expiry, only the recipient of the funds on the given chain is
    *         able to cancel. On the sending chain, this means only the router
    *         is able to cancel before the expiry, while only the user can
    *         prematurely cancel on the receiving chain.
    * @param txData All of the data (invariant and variant) for a crosschain
    *               transaction. The variant data provided is checked against
    *               what was stored when the `prepare` function was called.
    * @param signature The user's signature that allows a transaction to be
    *                  cancelled by a relayer
    */
  function cancel(TransactionData calldata txData, bytes calldata signature)
    external
    override
    nonReentrant
    returns (TransactionData memory)
  {
    // Make sure params match against stored data
    // Also checks that there is an active transfer here
    // Also checks that sender or receiver chainID is this chainId (bc we checked it previously)

    // Get the hash of the invariant tx data. This hash is the same
    // between sending and receiving chains. The variant data is stored
    // in the contract when `prepare` is called within the mapping.
    bytes32 digest = hashInvariantTransactionData(txData);

    // Verify the variant data is correct
    require(variantTransactionData[digest] == hashVariantTransactionData(txData.amount, txData.expiry, txData.preparedBlockNumber), "#C:019");

    // Make sure the transaction wasn't already completed
    require(txData.preparedBlockNumber > 0, "#C:021");

    // To prevent `fulfill` / `cancel` from being called multiple times, the
    // preparedBlockNumber is set to 0 before being hashed. The value of the
    // mapping is explicitly *not* zeroed out so users who come online without
    // a store can tell the difference between a transaction that has not been
    // prepared, and a transaction that was already completed on the receiver
    // chain.
    variantTransactionData[digest] = hashVariantTransactionData(txData.amount, txData.expiry, 0);

    // Get chainId for gas
    uint256 _chainId = getChainId();

    // Return the appropriate locked funds
    if (txData.sendingChainId == _chainId) {
      // Sender side, funds must be returned to the user
      if (txData.expiry >= block.timestamp) {
        // Timeout has not expired and tx may only be cancelled by router
        // NOTE: no need to validate the signature here, since you are requiring
        // the router must be the sender when the cancellation is during the
        // fulfill-able window
        require(msg.sender == txData.router, "#C:025");
      }

      // Return users locked funds
      // NOTE: no need to check if amount > 0 because cant be prepared on
      // sending chain with 0 value
      LibAsset.transferAsset(txData.sendingAssetId, payable(txData.sendingChainFallback), txData.amount);

    } else {
      // Receiver side, router liquidity is returned
      if (txData.expiry >= block.timestamp) {
        // Timeout has not expired and tx may only be cancelled by user
        // Validate signature
        require(msg.sender == txData.user || recoverCancelSignature(txData.transactionId, _chainId, address(this), signature) == txData.user, "#C:022");

        // NOTE: there is no incentive here for relayers to submit this on
        // behalf of the user (i.e. fee not respected) because the user has not
        // locked funds on this contract. However, if the user reveals their
        // cancel signature to the router, they are incentivized to submit it
        // to unlock their own funds
      }

      // Return liquidity to router
      routerBalances[txData.router][txData.receivingAssetId] += txData.amount;
    }

    // Emit event
    emit TransactionCancelled(txData.user, txData.router, txData.transactionId, txData, msg.sender);

    // Return
    return txData;
  }

  //////////////////////////
  /// Private functions ///
  //////////////////////////

  /**
    * @notice Contains the logic to verify + increment a given routers liquidity
    * @param amount The amount of liquidity to add for the router
    * @param assetId The address (or `address(0)` if native asset) of the
    *                asset you're adding liquidity for
    * @param router The router you are adding liquidity on behalf of
    */
  function _addLiquidityForRouter(
    uint256 amount,
    address assetId,
    address router
  ) internal {
    // Sanity check: router is sensible
    require(router != address(0), "#AL:001");

    // Sanity check: nonzero amounts
    require(amount > 0, "#AL:002");

    // Router is approved
    require(isRouterOwnershipRenounced() || approvedRouters[router], "#AL:003");

    // Asset is approved
    require(isAssetOwnershipRenounced() || approvedAssets[assetId], "#AL:004");

    // Transfer funds to contract
    amount = transferAssetToContract(assetId, amount);

    // Update the router balances. Happens after pulling funds to account for
    // the fee on transfer tokens
    routerBalances[router][assetId] += amount;

    // Emit event
    emit LiquidityAdded(router, assetId, amount, msg.sender);
  }

  /**
   * @notice Handles transferring funds from msg.sender to the
   *         transaction manager contract. Used in prepare, addLiquidity
   * @param assetId The address to transfer
   * @param specifiedAmount The specified amount to transfer. May not be the 
   *                        actual amount transferred (i.e. fee on transfer 
   *                        tokens)
   */
  function transferAssetToContract(address assetId, uint256 specifiedAmount) internal returns (uint256) {
    uint256 trueAmount = specifiedAmount;

    // Validate correct amounts are transferred
    if (LibAsset.isNativeAsset(assetId)) {
      require(msg.value == specifiedAmount, "#TA:005");
    } else {
      uint256 starting = LibAsset.getOwnBalance(assetId);
      require(msg.value == 0, "#TA:006");
      LibAsset.transferFromERC20(assetId, msg.sender, address(this), specifiedAmount);
      // Calculate the *actual* amount that was sent here
      trueAmount = LibAsset.getOwnBalance(assetId) - starting;
    }

    return trueAmount;
  }

  /// @notice Recovers the signer from the signature provided by the user
  /// @param transactionId Transaction identifier of tx being recovered
  /// @param signature The signature you are recovering the signer from
  function recoverCancelSignature(
    bytes32 transactionId,
    uint256 receivingChainId,
    address receivingChainTxManagerAddress,
    bytes calldata signature
  ) internal pure returns (address) {
    // Create the signed payload
    SignedCancelData memory payload = SignedCancelData({
      transactionId: transactionId,
      functionIdentifier: "cancel",
      receivingChainId: receivingChainId,
      receivingChainTxManagerAddress: receivingChainTxManagerAddress
    });

    // Recover
    return recoverSignature(abi.encode(payload), signature);
  }

  /**
    * @notice Recovers the signer from the signature provided by the user
    * @param transactionId Transaction identifier of tx being recovered
    * @param relayerFee The fee paid to the relayer for submitting the
    *                   tx on behalf of the user.
    * @param signature The signature you are recovering the signer from
    */
  function recoverFulfillSignature(
    bytes32 transactionId,
    uint256 relayerFee,
    uint256 receivingChainId,
    address receivingChainTxManagerAddress,
    bytes calldata signature
  ) internal pure returns (address) {
    // Create the signed payload
    SignedFulfillData memory payload = SignedFulfillData({
      transactionId: transactionId,
      relayerFee: relayerFee,
      functionIdentifier: "fulfill",
      receivingChainId: receivingChainId,
      receivingChainTxManagerAddress: receivingChainTxManagerAddress
    });

    // Recover
    return recoverSignature(abi.encode(payload), signature);
  }

  /**
    * @notice Holds the logic to recover the signer from an encoded payload.
    *         Will hash and convert to an eth signed message.
    * @param encodedPayload The payload that was signed
    * @param signature The signature you are recovering the signer from
    */
  function recoverSignature(bytes memory encodedPayload, bytes calldata  signature) internal pure returns (address) {
    // Recover
    return ECDSA.recover(
      ECDSA.toEthSignedMessageHash(keccak256(encodedPayload)),
      signature
    );
  }

  /**
    * @notice Returns the hash of only the invariant portions of a given
    *         crosschain transaction
    * @param txData TransactionData to hash
    */
  function hashInvariantTransactionData(TransactionData calldata txData) internal pure returns (bytes32) {
    InvariantTransactionData memory invariant = InvariantTransactionData({
      receivingChainTxManagerAddress: txData.receivingChainTxManagerAddress,
      user: txData.user,
      router: txData.router,
      sendingAssetId: txData.sendingAssetId,
      receivingAssetId: txData.receivingAssetId,
      sendingChainFallback: txData.sendingChainFallback,
      callTo: txData.callTo,
      receivingAddress: txData.receivingAddress,
      sendingChainId: txData.sendingChainId,
      receivingChainId: txData.receivingChainId,
      callDataHash: txData.callDataHash,
      transactionId: txData.transactionId
    });
    return keccak256(abi.encode(invariant));
  }

  /**
    * @notice Returns the hash of only the variant portions of a given
    *         crosschain transaction
    * @param amount amount to hash
    * @param expiry expiry to hash
    * @param preparedBlockNumber preparedBlockNumber to hash
    * @return Hash of the variant data
    *
    */
  function hashVariantTransactionData(uint256 amount, uint256 expiry, uint256 preparedBlockNumber) internal pure returns (bytes32) {
    VariantTransactionData memory variant = VariantTransactionData({
      amount: amount,
      expiry: expiry,
      preparedBlockNumber: preparedBlockNumber
    });
    return keccak256(abi.encode(variant));
  }

  /**
   * @notice Handles the receiving-chain fulfillment. This function should
   *         pay the relayer and either send funds to the specified address
   *         or execute the calldata. Will return a tuple of boolean,bytes
   *         indicating the success and return data of the external call.
   * @dev Separated from fulfill function to avoid stack too deep errors
   *
   * @param txData The TransactionData that needs to be fulfilled
   * @param relayerFee The fee to be paid to the relayer for submission
   * @param callData The data to be executed on the receiving chain
   *
   * @return Tuple representing (success, returnData) of the external call
   */
  function _receivingChainFulfill(
    TransactionData calldata txData,
    uint256 relayerFee,
    bytes calldata callData
  ) internal returns (bool, bytes memory) {
    // The user is completing the transaction, they should get the
    // amount that the router deposited less fees for relayer.

    // Get the amount to send
    uint256 toSend;
    unchecked {
      toSend = txData.amount - relayerFee;
    }

    // Send the relayer the fee
    if (relayerFee > 0) {
      LibAsset.transferAsset(txData.receivingAssetId, payable(msg.sender), relayerFee);
    }

    // Handle receiver chain external calls if needed
    if (txData.callTo == address(0)) {
      // No external calls, send directly to receiving address
      if (toSend > 0) {
        LibAsset.transferAsset(txData.receivingAssetId, payable(txData.receivingAddress), toSend);
      }
      return (false, new bytes(0));
    } else {
      // Handle external calls with a fallback to the receiving
      // address in case the call fails so the funds dont remain
      // locked.

      bool isNativeAsset = LibAsset.isNativeAsset(txData.receivingAssetId);

      // First, transfer the funds to the helper if needed
      if (!isNativeAsset && toSend > 0) {
        LibAsset.transferERC20(txData.receivingAssetId, address(interpreter), toSend);
      }

      // Next, call `execute` on the helper. Helpers should internally
      // track funds to make sure no one user is able to take all funds
      // for tx, and handle the case of reversions
      return interpreter.execute{ value: isNativeAsset ? toSend : 0}(
        txData.transactionId,
        payable(txData.callTo),
        txData.receivingAssetId,
        payable(txData.receivingAddress),
        toSend,
        callData
      );
    }
  }
}
