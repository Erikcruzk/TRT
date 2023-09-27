// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/IKeep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IKeep3rJob {
  event SetRewardMultiplier(uint256 _rewardMultiplier);

  function rewardMultiplier() external view returns (uint256 _rewardMultiplier);

  function setRewardMultiplier(uint256 _rewardMultiplier) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/v2/IV2Keep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.8;

interface IV2Keep3rJob is IKeep3rJob {
  // event Keep3rSet(address keep3r);
  event Keep3rHelperSet(address keep3rHelper);
  event SlidingOracleSet(address slidingOracle);

  // Setters
  event StrategyAdded(address _strategy, uint256 _requiredAmount);
  event StrategyModified(address _strategy, uint256 _requiredAmount);
  event StrategyRemoved(address _strategy);

  // Actions by Keeper
  event Worked(address _strategy, address _keeper, uint256 _credits);

  // Actions forced by governor
  event ForceWorked(address _strategy);

  // Getters
  function v2Keeper() external view returns (address _v2Keeper);

  function fastGasOracle() external view returns (address _fastGasOracle);

  function strategies() external view returns (address[] memory);

  function workable(address _strategy) external view returns (bool);

  // Setters
  function setV2Keep3r(address _v2Keeper) external;

  function setYOracle(address _v2Keeper) external;

  function setFastGasOracle(address _fastGasOracle) external;

  function setWorkCooldown(uint256 _workCooldown) external;

  function addStrategies(
    address[] calldata _strategy,
    uint256[] calldata _requiredAmount,
    address[] calldata _costTokens,
    address[] calldata _costPairs
  ) external;

  function addStrategy(
    address _strategy,
    uint256 _requiredAmount,
    address _costToken,
    address _costPair
  ) external;

  function updateRequiredAmounts(address[] calldata _strategies, uint256[] calldata _requiredAmounts) external;

  function updateRequiredAmount(address _strategy, uint256 _requiredAmount) external;

  function updateCostTokenAndPair(
    address _strategy,
    address _costToken,
    address _costPair
  ) external;

  function removeStrategy(address _strategy) external;

  // Keeper actions
  function work(address _strategy) external returns (uint256 _credits);

  // Mechanics keeper bypass
  function forceWork(address _strategy) external;
}