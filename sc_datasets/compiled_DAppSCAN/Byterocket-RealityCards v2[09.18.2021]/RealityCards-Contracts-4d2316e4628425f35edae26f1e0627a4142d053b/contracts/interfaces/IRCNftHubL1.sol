// File: ../sc_datasets/DAppSCAN/Byterocket-RealityCards v2[09.18.2021]/RealityCards-Contracts-4d2316e4628425f35edae26f1e0627a4142d053b/contracts/interfaces/IRCNftHubL1.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.7;

interface IRCNftHubL1 {
    function mint(address user, uint256 tokenId) external;

    function mint(
        address user,
        uint256 tokenId,
        bytes calldata metaData
    ) external;

    function exists(uint256 tokenId) external view returns (bool);
}
