// File: ../sc_datasets/DAppSCAN/PeckShield-Pandora/smart-contract-d0aa3193b8ffcd7fc84481c30e16283837319719/contracts/0.8.x/contracts/interfaces/IOracle.sol

// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;
pragma experimental ABIEncoderV2;

interface IOracle {
    function consult() external view returns (uint256);
}
