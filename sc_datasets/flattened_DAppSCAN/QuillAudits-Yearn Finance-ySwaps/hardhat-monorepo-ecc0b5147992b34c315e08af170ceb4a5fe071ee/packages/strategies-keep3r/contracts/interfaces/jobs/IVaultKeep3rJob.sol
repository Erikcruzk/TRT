// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/IKeep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IKeep3rJob {
  event SetRewardMultiplier(uint256 _rewardMultiplier);

  function rewardMultiplier() external view returns (uint256 _rewardMultiplier);

  function setRewardMultiplier(uint256 _rewardMultiplier) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/IVaultKeep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IVaultKeep3rJob is IKeep3rJob {
  event VaultAdded(address _vault, uint256 _requiredEarn);
  event VaultModified(address _vault, uint256 _requiredEarn);
  event VaultRemoved(address _vault);

  // Actions by Keeper
  event Worked(address _vault, address _keeper, uint256 _credits);

  // Actions forced by Governor
  event ForceWorked(address _vault);

  // Setters
  function addVaults(address[] calldata _vaults, uint256[] calldata _requiredEarns) external;

  function addVault(address _vault, uint256 _requiredEarn) external;

  function updateVaults(address[] calldata _vaults, uint256[] calldata _requiredEarns) external;

  function updateVault(address _vault, uint256 _requiredEarn) external;

  function removeVault(address _vault) external;

  function setEarnCooldown(uint256 _earnCooldown) external;

  // Getters
  function workable(address _vault) external returns (bool);

  function vaults() external view returns (address[] memory _vaults);

  function calculateEarn(address _vault) external view returns (uint256 _amount);

  // Keeper actions
  function work(address _vault) external returns (uint256 _credits);

  // Mechanics keeper bypass
  function forceWork(address _vault) external;
}
