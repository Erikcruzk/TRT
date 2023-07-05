// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/IKeep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IKeep3rJob {
  event SetRewardMultiplier(uint256 _rewardMultiplier);

  function rewardMultiplier() external view returns (uint256 _rewardMultiplier);

  function setRewardMultiplier(uint256 _rewardMultiplier) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/ICrvStrategyKeep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ICrvStrategyKeep3rJob is IKeep3rJob {
  event StrategyAdded(address _strategy, uint256 _requiredHarvest, uint256 _requiredEarn);
  event StrategyModified(address _strategy, uint256 _requiredHarvest, uint256 _requiredEarn);
  event StrategyRemoved(address _strategy);

  // Actions by Keeper
  event Worked(address _strategy, address _keeper, uint256 _credits);

  // Actions forced by governor
  event ForceWorked(address _strategy);

  // Setters
  function addStrategies(
    address[] calldata _strategies,
    uint256[] calldata _requiredHarvests,
    uint256[] calldata _requiredEarns
  ) external;

  function addStrategy(
    address _strategy,
    uint256 _requiredHarvest,
    uint256 _requiredEarn
  ) external;

  function updateStrategies(
    address[] calldata _strategies,
    uint256[] calldata _requiredHarvests,
    uint256[] calldata _requiredEarns
  ) external;

  function updateStrategy(
    address _strategy,
    uint256 _requiredHarvest,
    uint256 _requiredEarn
  ) external;

  function removeStrategy(address _strategy) external;

  function setMaxHarvestPeriod(uint256 _maxHarvestPeriod) external;

  function setHarvestCooldown(uint256 _harvestCooldown) external;

  // Getters
  function strategies() external view returns (address[] memory _strategies);

  function workable(address _strategy) external returns (bool);

  function requiredHarvest(address _strategy) external view returns (uint256 _requiredHarvest);

  function requiredEarn(address _strategy) external view returns (uint256 _requiredEarn);

  function lastWorkAt(address _strategy) external view returns (uint256 _lastWorkAt);

  function maxHarvestPeriod() external view returns (uint256 _maxHarvestPeriod);

  function lastHarvest() external view returns (uint256 _lastHarvest);

  function harvestCooldown() external view returns (uint256 _harvestCooldown);

  function calculateHarvest(address _strategy) external returns (uint256 _amount);

  // Keeper actions
  function work(address _strategy) external returns (uint256 _credits);

  // Mechanics keeper bypass
  function forceWork(address _strategy) external;
}
