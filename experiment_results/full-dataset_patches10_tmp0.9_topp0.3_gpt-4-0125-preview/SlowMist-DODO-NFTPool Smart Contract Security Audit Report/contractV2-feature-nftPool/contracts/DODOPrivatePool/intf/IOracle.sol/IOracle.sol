// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-NFTPool Smart Contract Security Audit Report/contractV2-feature-nftPool/contracts/DODOPrivatePool/intf/IOracle.sol

/*

    Copyright 2021 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;

interface IOracle {
    function getPrice(address base) external view returns (uint256 latestPrice,bool isValid,bool isStale,uint256 timestamp);    
}