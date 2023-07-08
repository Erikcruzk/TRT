// File: ../sc_datasets/DAppSCAN/PeckShield-Pandora/smart-contract-d0aa3193b8ffcd7fc84481c30e16283837319719/contracts/0.6.x/contracts/interfaces/ISwapAdapter.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;

interface ISwapAdapter {

    function sellBase(address to, address pool, bytes memory data) external;

    function sellQuote(address to, address pool, bytes memory data) external;
}
