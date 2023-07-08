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

// File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

pragma solidity ^0.8.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/composable/TopDownERC20Composable.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;






interface ERC998ERC20TopDown {
    event ReceivedERC20(address indexed _from, uint256 indexed _tokenId, address indexed _erc20Contract, uint256 _value);
    event ReceivedERC20ForEdition(address indexed _from, uint256 indexed _editionId, address indexed _erc20Contract, uint256 _value);
    event TransferERC20(uint256 indexed _tokenId, address indexed _to, address indexed _erc20Contract, uint256 _value);

    function balanceOfERC20(uint256 _tokenId, address _erc20Contract) external view returns (uint256);

    function transferERC20(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) external;

    function getERC20(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) external;
}

interface ERC998ERC20TopDownEnumerable {
    function totalERC20Contracts(uint256 _tokenId) external view returns (uint256);

    function erc20ContractByIndex(uint256 _tokenId, uint256 _index) external view returns (address);
}

/// @notice ERC998 ERC721 > ERC20 Top Down implementation
abstract contract TopDownERC20Composable is ERC998ERC20TopDown, ERC998ERC20TopDownEnumerable, ReentrancyGuard, Context {
    using EnumerableSet for EnumerableSet.AddressSet;

    // Edition ID -> ERC20 contract -> Balance of ERC20 for every token in Edition
    mapping(uint256 => mapping(address => uint256)) public editionTokenERC20Balances;

    // Edition ID -> ERC20 contract -> Token ID -> Balance Transferred out of token
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) public editionTokenERC20TransferAmounts;

    // Edition ID -> Linked ERC20 contract addresses
    mapping(uint256 => EnumerableSet.AddressSet) ERC20sEmbeddedInEdition;

    // Token ID -> Linked ERC20 contract addresses
    mapping(uint256 => EnumerableSet.AddressSet) ERC20sEmbeddedInNft;

    // Token ID -> ERC20 contract -> balance of ERC20 owned by token
    mapping(uint256 => mapping(address => uint256)) public ERC20Balances;

    /// @notice the ERC20 balance of a NFT token given an ERC20 token address
    function balanceOfERC20(uint256 _tokenId, address _erc20Contract) public override view returns (uint256) {
        IKODAV3 koda = IKODAV3(address(this));
        uint256 editionId = koda.getEditionIdOfToken(_tokenId);

        uint256 editionBalance = editionTokenERC20Balances[editionId][_erc20Contract];
        uint256 tokenEditionBalance = editionBalance / koda.getSizeOfEdition(editionId);
        uint256 spentTokens = editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId];
        tokenEditionBalance = tokenEditionBalance - spentTokens;

        return tokenEditionBalance + ERC20Balances[_tokenId][_erc20Contract];
    }

    /// @notice Transfer out an ERC20 from an NFT
    function transferERC20(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) external override nonReentrant {
        _prepareERC20LikeTransfer(_tokenId, _to, _erc20Contract, _value);

        IERC20(_erc20Contract).transfer(_to, _value);

        emit TransferERC20(_tokenId, _to, _erc20Contract, _value);
    }

    /// @notice An NFT token owner (or approved) can compose multiple ERC20s in their NFT
    function getERC20s(address _from, uint256[] calldata _tokenIds, address _erc20Contract, uint256 _totalValue) external {
        uint256 totalTokens = _tokenIds.length;
        require(totalTokens > 0 && _totalValue > 0, "Empty values");

        uint256 valuePerToken = _totalValue / totalTokens;
        for (uint i = 0; i < totalTokens; i++) {
            getERC20(_from, _tokenIds[i], _erc20Contract, valuePerToken);
        }
    }

    /// @notice A NFT token owner (or approved address) can compose any ERC20 in their NFT
    function getERC20(address _from, uint256 _tokenId, address _erc20Contract, uint256 _value) public override nonReentrant {
        require(_value > 0, "Value zero");
        require(_from == _msgSender(), "Only owner");

        address spender = _msgSender();
        IERC721 self = IERC721(address(this));

        address owner = self.ownerOf(_tokenId);
        require(
            owner == spender || self.isApprovedForAll(owner, spender) || self.getApproved(_tokenId) == spender,
            "Invalid spender"
        );

        uint256 editionId = IKODAV3(address(this)).getEditionIdOfToken(_tokenId);
        bool editionAlreadyContainsERC20 = ERC20sEmbeddedInEdition[editionId].contains(_erc20Contract);
        bool nftAlreadyContainsERC20 = ERC20sEmbeddedInNft[_tokenId].contains(_erc20Contract);

        // does not already contain _erc20Contract
        if (!editionAlreadyContainsERC20 && !nftAlreadyContainsERC20) {
            ERC20sEmbeddedInNft[_tokenId].add(_erc20Contract);
        }

        ERC20Balances[_tokenId][_erc20Contract] = ERC20Balances[_tokenId][_erc20Contract] + _value;

        IERC20 token = IERC20(_erc20Contract);
        require(token.allowance(_from, address(this)) >= _value, "Exceeds allowance");

        token.transferFrom(_from, address(this), _value);

        emit ReceivedERC20(_from, _tokenId, _erc20Contract, _value);
    }

    function _composeERC20IntoEdition(address _from, uint256 _editionId, address _erc20Contract, uint256 _value) internal nonReentrant {
        require(_value > 0, "Value zero");

        require(!ERC20sEmbeddedInEdition[_editionId].contains(_erc20Contract), "Edition contains ERC20");

        ERC20sEmbeddedInEdition[_editionId].add(_erc20Contract);
        editionTokenERC20Balances[_editionId][_erc20Contract] = editionTokenERC20Balances[_editionId][_erc20Contract] + _value;

        IERC20(_erc20Contract).transferFrom(_from, address(this), _value);

        emit ReceivedERC20ForEdition(_from, _editionId, _erc20Contract, _value);
    }

    function totalERC20Contracts(uint256 _tokenId) override public view returns (uint256) {
        uint256 editionId = IKODAV3(address(this)).getEditionIdOfToken(_tokenId);
        return ERC20sEmbeddedInNft[_tokenId].length() + ERC20sEmbeddedInEdition[editionId].length();
    }

    function erc20ContractByIndex(uint256 _tokenId, uint256 _index) override external view returns (address) {
        uint256 numOfERC20sInNFT = ERC20sEmbeddedInNft[_tokenId].length();
        if (_index >= numOfERC20sInNFT) {
            uint256 editionId =  IKODAV3(address(this)).getEditionIdOfToken(_tokenId);
            return ERC20sEmbeddedInEdition[editionId].at(_index - numOfERC20sInNFT);
        }

        return ERC20sEmbeddedInNft[_tokenId].at(_index);
    }

    /// --- Internal ----

    function _prepareERC20LikeTransfer(uint256 _tokenId, address _to, address _erc20Contract, uint256 _value) private {
        // To avoid stack too deep, do input checks within this scope
        {
            require(_value > 0, "Value zero");
            require(_to != address(0), "Zero address");

            IERC721 self = IERC721(address(this));

            address owner = self.ownerOf(_tokenId);
            require(
                owner == _msgSender() || self.isApprovedForAll(owner, _msgSender()) || self.getApproved(_tokenId) == _msgSender(),
                "Not owner"
            );
        }

        // Check that the NFT contains the ERC20
        bool nftContainsERC20 = ERC20sEmbeddedInNft[_tokenId].contains(_erc20Contract);

        IKODAV3 koda = IKODAV3(address(this));
        uint256 editionId = koda.getEditionIdOfToken(_tokenId);
        bool editionContainsERC20 = ERC20sEmbeddedInEdition[editionId].contains(_erc20Contract);
        require(nftContainsERC20 || editionContainsERC20, "No such ERC20");

        // Check there is enough balance to transfer out
        require(balanceOfERC20(_tokenId, _erc20Contract) >= _value, "Exceeds balance");

        uint256 editionSize = koda.getSizeOfEdition(editionId);
        uint256 tokenInitialBalance = editionTokenERC20Balances[editionId][_erc20Contract] / editionSize;
        uint256 spentTokens = editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId];
        uint256 editionTokenBalance = tokenInitialBalance - spentTokens;

        // Check whether the value can be fully transferred from the edition balance, token balance or both balances
        if (editionTokenBalance >= _value) {
            editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId] = spentTokens + _value;
        } else if (ERC20Balances[_tokenId][_erc20Contract] >= _value) {
            ERC20Balances[_tokenId][_erc20Contract] = ERC20Balances[_tokenId][_erc20Contract] - _value;
        } else {
            // take from both balances
            editionTokenERC20TransferAmounts[editionId][_erc20Contract][_tokenId] = spentTokens + editionTokenBalance;
            uint256 amountOfTokensToSpendFromTokenBalance = _value - editionTokenBalance;
            ERC20Balances[_tokenId][_erc20Contract] = ERC20Balances[_tokenId][_erc20Contract] - amountOfTokensToSpendFromTokenBalance;
        }

        // The ERC20 is no longer composed within the token if the balance falls to zero
        if (nftContainsERC20 && ERC20Balances[_tokenId][_erc20Contract] == 0) {
            ERC20sEmbeddedInNft[_tokenId].remove(_erc20Contract);
        }

        // If all tokens in an edition have spent their ERC20 balance, then we can remove the link
        if (editionContainsERC20) {
            uint256 allTokensInEditionERC20Balance;
            for (uint i = 0; i < editionSize; i++) {
                uint256 tokenBal = tokenInitialBalance - editionTokenERC20TransferAmounts[editionId][_erc20Contract][editionId + i];
                allTokensInEditionERC20Balance = allTokensInEditionERC20Balance + tokenBal;
            }

            if (allTokensInEditionERC20Balance == 0) {
                ERC20sEmbeddedInEdition[editionId].remove(_erc20Contract);
            }
        }
    }
}
