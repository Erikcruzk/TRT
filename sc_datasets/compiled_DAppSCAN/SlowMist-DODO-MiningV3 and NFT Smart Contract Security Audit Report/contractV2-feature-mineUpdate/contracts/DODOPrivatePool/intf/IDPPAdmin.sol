// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/DODOPrivatePool/intf/IDPPAdmin.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface IDPPAdmin {
    function init(address owner, address dpp,address operator, address dodoSmartApprove) external;
}
