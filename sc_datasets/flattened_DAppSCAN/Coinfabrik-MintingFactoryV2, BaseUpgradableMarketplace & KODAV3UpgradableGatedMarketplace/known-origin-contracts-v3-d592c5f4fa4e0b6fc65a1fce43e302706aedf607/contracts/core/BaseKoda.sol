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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/Konstants.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract Konstants {

    // Every edition always goes up in batches of 1000
    uint16 public constant MAX_EDITION_SIZE = 1000;

    // magic method that defines the maximum range for an edition - this is fixed forever - tokens are minted in range
    function _editionFromTokenId(uint256 _tokenId) internal pure returns (uint256) {
        return (_tokenId / MAX_EDITION_SIZE) * MAX_EDITION_SIZE;
    }
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/core/BaseKoda.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;




abstract contract BaseKoda is Konstants, Context, IKODAV3 {

    bytes4 constant internal ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    event AdminUpdateSecondaryRoyalty(uint256 _secondarySaleRoyalty);
    event AdminUpdateBasisPointsModulo(uint256 _basisPointsModulo);
    event AdminUpdateModulo(uint256 _modulo);
    event AdminEditionReported(uint256 indexed _editionId, bool indexed _reported);
    event AdminArtistAccountReported(address indexed _account, bool indexed _reported);
    event AdminUpdateAccessControls(IKOAccessControlsLookup indexed _oldAddress, IKOAccessControlsLookup indexed _newAddress);

    modifier onlyContract(){
        _onlyContract();
        _;
    }

    function _onlyContract() private view {
        require(accessControls.hasContractRole(_msgSender()), "Must be contract");
    }

    modifier onlyAdmin(){
        _onlyAdmin();
        _;
    }

    function _onlyAdmin() private view {
        require(accessControls.hasAdminRole(_msgSender()), "Must be admin");
    }

    IKOAccessControlsLookup public accessControls;

    // A onchain reference to editions which have been reported for some infringement purposes to KO
    mapping(uint256 => bool) public reportedEditionIds;

    // A onchain reference to accounts which have been lost/hacked etc
    mapping(address => bool) public reportedArtistAccounts;

    // Secondary sale commission
    uint256 public secondarySaleRoyalty = 12_50000; // 12.5% by default

    /// @notice precision 100.00000%
    uint256 public modulo = 100_00000;

    /// @notice Basis points conversion modulo
    /// @notice This is used by the IHasSecondarySaleFees implementation which is different than EIP-2981 specs
    uint256 public basisPointsModulo = 1000;

    constructor(IKOAccessControlsLookup _accessControls) {
        accessControls = _accessControls;
    }

    function reportEditionId(uint256 _editionId, bool _reported) onlyAdmin public {
        reportedEditionIds[_editionId] = _reported;
        emit AdminEditionReported(_editionId, _reported);
    }

    function reportArtistAccount(address _account, bool _reported) onlyAdmin public {
        reportedArtistAccounts[_account] = _reported;
        emit AdminArtistAccountReported(_account, _reported);
    }

    function updateBasisPointsModulo(uint256 _basisPointsModulo) onlyAdmin public {
        require(_basisPointsModulo > 0, "Is zero");
        basisPointsModulo = _basisPointsModulo;
        emit AdminUpdateBasisPointsModulo(_basisPointsModulo);
    }

    function updateModulo(uint256 _modulo) onlyAdmin public {
        require(_modulo > 0, "Is zero");
        modulo = _modulo;
        emit AdminUpdateModulo(_modulo);
    }

    function updateSecondaryRoyalty(uint256 _secondarySaleRoyalty) onlyAdmin public {
        secondarySaleRoyalty = _secondarySaleRoyalty;
        emit AdminUpdateSecondaryRoyalty(_secondarySaleRoyalty);
    }

    function updateAccessControls(IKOAccessControlsLookup _accessControls) public onlyAdmin {
        require(_accessControls.hasAdminRole(_msgSender()), "Must be admin");
        emit AdminUpdateAccessControls(accessControls, _accessControls);
        accessControls = _accessControls;
    }

    /// @dev Allows for the ability to extract stuck ERC20 tokens
    /// @dev Only callable from admin
    function withdrawStuckTokens(address _tokenAddress, uint256 _amount, address _withdrawalAccount) onlyAdmin public {
        IERC20(_tokenAddress).transfer(_withdrawalAccount, _amount);
    }
}
