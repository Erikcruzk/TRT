// File: ../sc_datasets/DAppSCAN/Quantstamp-SeleCT x StormX NFT/nft-shrug-1d5d0ec1986b692d50d45e0a6d597bf97697a576/contracts/fake/ETHUSDAggregator.sol

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract ETHUSDAggregator {
    int256 temp = 250729030969;

    function latestAnswer() external view returns (int256) {
        return temp;
    }
}