// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/yearn/IV1Controller.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IV1Controller {
  function stretegies(address _want) external view returns (address _strategy);

  function vaults(address _want) external view returns (address _vault);
}