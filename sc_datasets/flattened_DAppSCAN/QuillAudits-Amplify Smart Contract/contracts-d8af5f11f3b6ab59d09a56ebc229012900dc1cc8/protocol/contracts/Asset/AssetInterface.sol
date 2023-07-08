// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/ERC721/IERC721.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);

    function balanceOf(address owner) external view returns (uint balance);
    function ownerOf(uint tokenId) external view returns (address owner);
    
    function transferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint tokenId) external;
}

interface IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint tokenId) external view returns (string memory);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Amplify Smart Contract/contracts-d8af5f11f3b6ab59d09a56ebc229012900dc1cc8/protocol/contracts/Asset/AssetInterface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract AssetInterface is IERC721 {
    bool public isAssetsFactory = true;

    function getTokenInfo(uint256 _tokenId) external virtual view returns (uint256, uint256, uint256, uint256, string memory, string memory, address, bool);
    function markAsRedeemed(uint256 tokenId) external virtual;
}
