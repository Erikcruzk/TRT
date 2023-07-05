// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/yearn/IHarvestableStrategy.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IHarvestableStrategy {
  function harvest() external;

  function controller() external view returns (address);

  function want() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/dforce/IDforceStrategy.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IDforceStrategy is IHarvestableStrategy {
  function pool() external pure returns (address);
}
