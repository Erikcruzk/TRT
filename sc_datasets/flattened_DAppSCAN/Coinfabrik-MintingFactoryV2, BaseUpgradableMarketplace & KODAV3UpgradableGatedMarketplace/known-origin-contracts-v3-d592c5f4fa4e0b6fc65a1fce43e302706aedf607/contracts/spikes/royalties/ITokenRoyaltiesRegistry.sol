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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/spikes/royalties/ITokenRoyaltiesRegistry.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface ITokenRoyaltiesRegistry is IERC2981 {

    // get total payable royalties recipients
    function totalPotentialRoyalties(uint256 _tokenId) external view returns (uint256);

    // get total payable royalties recipients
    function royaltyParticipantAtIndex(uint256 _tokenId, uint256 _index) external view returns (address, uint256);

    // immutable single time only call - call on token creation by default
    function defineRoyalty(uint256 _tokenId, address _recipient, uint256 _amount) external;

    // enable staged multi-sig style approved joint royalty
    function initMultiOwnerRoyalty(uint256 _tokenId, address _defaultRecipient, uint256 _defaultRoyalty, address[] calldata _recipients, uint256[] calldata _amounts) external;

    // confirm token share - approve use of joint holder
    function confirm(uint256 _tokenId, uint8[] calldata _sigV, bytes32[] calldata _sigR, bytes32[] calldata _sigS) external;

    // reject token share - removes from potential multi-sig address
    function reject(uint256 _tokenId, uint256 _quitterIndex) external;
}
