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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/access/IKOAccessControlsLookup.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface IKOAccessControlsLookup {
    function hasAdminRole(address _address) external view returns (bool);

    function isVerifiedArtist(uint256 _index, address _account, bytes32[] calldata _merkleProof) external view returns (bool);

    function isVerifiedArtistProxy(address _artist, address _proxy) external view returns (bool);

    function hasLegacyMinterRole(address _address) external view returns (bool);

    function hasContractRole(address _address) external view returns (bool);

    function hasContractOrAdminRole(address _address) external view returns (bool);
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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/IERC2309.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/**
  @title ERC-2309: ERC-721 Batch Mint Extension
  @dev https://github.com/ethereum/EIPs/issues/2309
 */
interface IERC2309 {
    /**
      @notice This event is emitted when ownership of a batch of tokens changes by any mechanism.
      This includes minting, transferring, and burning.

      @dev The address executing the transaction MUST own all the tokens within the range of
      fromTokenId and toTokenId, or MUST be an approved operator to act on the owners behalf.
      The fromTokenId and toTokenId MUST be a sequential range of tokens IDs.
      When minting/creating tokens, the `fromAddress` argument MUST be set to `0x0` (i.e. zero address).
      When burning/destroying tokens, the `toAddress` argument MUST be set to `0x0` (i.e. zero address).

      @param fromTokenId The token ID that begins the batch of tokens being transferred
      @param toTokenId The token ID that ends the batch of tokens being transferred
      @param fromAddress The address transferring ownership of the specified range of tokens
      @param toAddress The address receiving ownership of the specified range of tokens.
    */
    event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed fromAddress, address indexed toAddress);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/IERC2981.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/// @notice This is purely an extension for the KO platform
/// @notice Royalties on KO are defined at an edition level for all tokens from the same edition
interface IERC2981EditionExtension {

    /// @notice Does the edition have any royalties defined
    function hasRoyalties(uint256 _editionId) external view returns (bool);

    /// @notice Get the royalty receiver - all royalties should be sent to this account if not zero address
    function getRoyaltiesReceiver(uint256 _editionId) external view returns (address);
}

/**
 * ERC2981 standards interface for royalties
 */
interface IERC2981 is IERC165, IERC2981EditionExtension {
    /// ERC165 bytes to add to interface array - set in parent contract
    /// implementing this standard
    ///
    /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
    /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    /// _registerInterface(_INTERFACE_ID_ERC2981);

    /// @notice Called with the sale price to determine how much royalty
    //          is owed and to whom.
    /// @param _tokenId - the NFT asset queried for royalty information
    /// @param _value - the sale price of the NFT asset specified by _tokenId
    /// @return _receiver - address of who should be sent the royalty payment
    /// @return _royaltyAmount - the royalty payment amount for _value sale price
    function royaltyInfo(
        uint256 _tokenId,
        uint256 _value
    ) external view returns (
        address _receiver,
        uint256 _royaltyAmount
    );

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/IHasSecondarySaleFees.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

/// @title Royalties formats required for use on the Rarible platform
/// @dev https://docs.rarible.com/asset/royalties-schema
interface IHasSecondarySaleFees is IERC165 {

    event SecondarySaleFees(uint256 tokenId, address[] recipients, uint[] bps);

    function getFeeRecipients(uint256 id) external returns (address payable[] memory);

    function getFeeBps(uint256 id) external returns (uint[] memory);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/IKODAV3.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;





/// @title Core KODA V3 functionality
interface IKODAV3 is
IERC165, // Contract introspection
IERC721, // Core NFTs
IERC2309, // Consecutive batch mint
IERC2981, // Royalties
IHasSecondarySaleFees // Rariable / Foundation royalties
{
    // edition utils

    function getCreatorOfEdition(uint256 _editionId) external view returns (address _originalCreator);

    function getCreatorOfToken(uint256 _tokenId) external view returns (address _originalCreator);

    function getSizeOfEdition(uint256 _editionId) external view returns (uint256 _size);

    function getEditionSizeOfToken(uint256 _tokenId) external view returns (uint256 _size);

    function editionExists(uint256 _editionId) external view returns (bool);

    // Has the edition been disabled / soft burnt
    function isEditionSalesDisabled(uint256 _editionId) external view returns (bool);

    // Has the edition been disabled / soft burnt OR sold out
    function isSalesDisabledOrSoldOut(uint256 _editionId) external view returns (bool);

    // Work out the max token ID for an edition ID
    function maxTokenIdOfEdition(uint256 _editionId) external view returns (uint256 _tokenId);

    // Helper method for getting the next primary sale token from an edition starting low to high token IDs
    function getNextAvailablePrimarySaleToken(uint256 _editionId) external returns (uint256 _tokenId);

    // Helper method for getting the next primary sale token from an edition starting high to low token IDs
    function getReverseAvailablePrimarySaleToken(uint256 _editionId) external view returns (uint256 _tokenId);

    // Utility method to get all data needed for the next primary sale, low token ID to high
    function facilitateNextPrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);

    // Utility method to get all data needed for the next primary sale, high token ID to low
    function facilitateReversePrimarySale(uint256 _editionId) external returns (address _receiver, address _creator, uint256 _tokenId);

    // Expanded royalty method for the edition, not token
    function royaltyAndCreatorInfo(uint256 _editionId, uint256 _value) external returns (address _receiver, address _creator, uint256 _amount);

    // Allows the creator to correct mistakes until the first token from an edition is sold
    function updateURIIfNoSaleMade(uint256 _editionId, string calldata _newURI) external;

    // Has any primary transfer happened from an edition
    function hasMadePrimarySale(uint256 _editionId) external view returns (bool);

    // Has the edition sold out
    function isEditionSoldOut(uint256 _editionId) external view returns (bool);

    // Toggle on/off the edition from being able to make sales
    function toggleEditionSalesDisabled(uint256 _editionId) external;

    // token utils

    function exists(uint256 _tokenId) external view returns (bool);

    function getEditionIdOfToken(uint256 _tokenId) external pure returns (uint256 _editionId);

    function getEditionDetails(uint256 _tokenId) external view returns (address _originalCreator, address _owner, uint16 _size, uint256 _editionId, string memory _uri);

    function hadPrimarySaleOfToken(uint256 _tokenId) external view returns (bool);

}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/marketplace/KODAV3SignatureMarketplace.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;





contract KODAV3SignatureMarketplace is ReentrancyGuard, Context {

    // Contract name
    string public constant name = "KODAV3SignatureMarketplace";

    // marketplace version
    string public constant version = "3";

    // edition buy now
    event EditionPurchased(uint256 indexed _editionId, uint256 indexed _tokenId, address indexed _buyer, uint256 _price);

    // KO commission
    uint256 public platformPrimarySaleCommission = 15_00000;  // 15.00000%
    uint256 public platformSecondarySaleCommission = 2_50000;  // 2.50000%

    // precision 100.00000%
    uint256 public modulo = 100_00000;

    // address -> Edition ID -> nonce
    mapping(address => mapping(uint256 => uint256)) public listingNonces;

    // Permit domain
    bytes32 public DOMAIN_SEPARATOR;

    // keccak256("Permit(address _creator,address _editionId,uint256 _price,address _paymentToken,uint256 _startDate,uint256 nonce)");
    bytes32 public constant PERMIT_TYPEHASH = 0xe5ea8149e9b023b903163e5566c4bfbc4b3ca830f7f5f70157b91046afe0bc87;

    // FIXME get GAS costings for using a counter and draw down method for KO funds?
    // platform funds collector
    address public platformAccount;

    // TODO Ability to set price/listing in multiple tokens e.g. ETH / DAI / WETH / WBTC
    //      - do we need a list of tokens to allow payments in?
    //      - is this really a different contract?

    // TODO Multi coin payment support
    //      - approved list of tokens?
    //      - reentrancy safe
    //      - requires user approval to buy
    //      - can only be listed in ETH or ERC20/223 ?

    IKODAV3 public koda;
    IKOAccessControlsLookup public accessControls;

    constructor(
        IKOAccessControlsLookup _accessControls,
        IKODAV3 _koda,
        address _platformAccount
    ) {
        koda = _koda;
        platformAccount = _platformAccount;
        accessControls = _accessControls;

        // Grab chain ID
        uint256 chainId;
        assembly {chainId := chainid()}

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                address(this)
            ));
    }

    function isListingValid(
        address _creator,
        uint256 _editionId,
        uint256 _price,
        address _paymentToken,
        uint256 _startDate,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public view returns (bool) {
        // Create digest to check signatures
        bytes32 digest = getListingDigest(
            _creator,
            _editionId,
            _price,
            _paymentToken,
            _startDate
        );

        return ecrecover(digest, _v, _r, _s) == _creator;
    }

    function buyEditionToken(
        address _creator,
        uint256 _editionId,
        uint256 _price,
        address _paymentToken,
        uint256 _startDate,
        uint256 _nonce,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public payable nonReentrant {
        require(
            isListingValid(
                _creator,
                _editionId,
                _price,
                _paymentToken,
                _startDate,
                _v,
                _r,
                _s
            ),
            "Invalid listing"
        );

        require(block.timestamp >= _startDate, "Tokens not available for purchase yet");

        if (_paymentToken == address(0)) {
            require(msg.value >= _price, "List price in ETH not satisfied");
        }

        uint256 tokenId = facilitateNextPrimarySale(
            _creator,
            _editionId,
            _paymentToken,
            _price,
            _msgSender()
        );

        emit EditionPurchased(_editionId, tokenId, _msgSender(), _price);
    }

    function invalidateListingNonce(uint256 _editionId) public {
        listingNonces[_msgSender()][_editionId] = listingNonces[_msgSender()][_editionId] + 1;
    }

    function getListingDigest(
        address _creator,
        uint256 _editionId,
        uint256 _price,
        address _paymentToken,
        uint256 _startDate
    ) public view returns (bytes32) {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, _creator, _editionId, _price, _paymentToken, _startDate, listingNonces[_creator][_editionId] + 1))
            )
        );
    }

    function facilitateNextPrimarySale(address _from, uint256 _editionId, address _paymentToken, uint256 _paymentAmount, address _buyer) internal returns (uint256) {
        // get next token to sell along with the royalties recipient and the original creator
        (address receiver, address creator, uint256 tokenId) = koda.facilitateNextPrimarySale(_editionId);

        // split money
        handleEditionSaleFunds(receiver, _paymentToken, _paymentAmount);

        // send token to buyer (assumes approval has been made, if not then this will fail)
        koda.safeTransferFrom(_from, _buyer, tokenId);

        // FIXME we could in theory remove this
        //      - and use the current approach of KO where a bidder must pull back any funds once its sold out on primary
        //      - would probs shave a good bit of GAS (profile the options)
        //      - could be replaced with a open method when in that state, monies are returned to bidder (future proof building tools to cover this)

        //todo: sell out logic
        // if we are about to sellout - send any open offers back to the bidder
        //        if (tokenId == koda.maxTokenIdOfEdition(_editionId)) {
        //
        //            // send money back to top bidder if existing offer found
        //            Offer storage offer = editionOffers[_editionId];
        //            if (offer.offer > 0) {
        //                _refundBidder(offer.bidder, offer.offer);
        //            }
        //        }

        return tokenId;
    }

    function handleEditionSaleFunds(address _receiver, address _paymentToken, uint256 _paymentAmount) internal {

        // TODO could we save gas here by maintaining a counter for KO platform funds and having a drain method?

        bool _isEthSale = _paymentToken == address(0);
        uint256 koCommission = (_paymentAmount / modulo) * platformPrimarySaleCommission;
        uint256 receiverCommission = _paymentAmount - koCommission;
        if (_isEthSale) {
            (bool koCommissionSuccess,) = platformAccount.call{value : koCommission}("");
            require(koCommissionSuccess, "Edition commission payment failed");

            (bool success,) = _receiver.call{value : receiverCommission}("");
            require(success, "Edition payment failed");
        } else {
            IERC20 paymentToken = IERC20(_paymentToken);
            paymentToken.transferFrom(_msgSender(), platformAccount, koCommission);
            paymentToken.transferFrom(_msgSender(), _receiver, receiverCommission);
        }
    }

    function getChainId() public view returns (uint256) {
        uint256 chainId;
        assembly {chainId := chainid()}
        return chainId;
    }
}
