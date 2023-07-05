// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/programmable/ITokenUriResolver.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface ITokenUriResolver {

    /// @notice Return the edition or token level URI - token level trumps edition level if found
    function tokenURI(uint256 _editionId, uint256 _tokenId) external view returns (string memory);

    /// @notice Do we have an edition level or token level token URI resolver set
    function isDefined(uint256 _editionId, uint256 _tokenId) external view returns (bool);
}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-MintingFactoryV2, BaseUpgradableMarketplace & KODAV3UpgradableGatedMarketplace/known-origin-contracts-v3-d592c5f4fa4e0b6fc65a1fce43e302706aedf607/contracts/mock/MockTokenUriResolver.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

// N:B: Mock contract for testing purposes only
contract MockTokenUriResolver is ITokenUriResolver {

    mapping(uint256 => string) overrides;

    function tokenURI(uint256 _editionId, uint256 _tokenId) external override view returns (string memory) {
        return overrides[_editionId];
    }

    function isDefined(uint256 _editionId, uint256 _tokenId) external override view returns (bool){
        return bytes(overrides[_editionId]).length > 0;
    }

    function setEditionUri(uint256 _editionId, string memory _uri) public {
        overrides[_editionId] = _uri;
    }
}
