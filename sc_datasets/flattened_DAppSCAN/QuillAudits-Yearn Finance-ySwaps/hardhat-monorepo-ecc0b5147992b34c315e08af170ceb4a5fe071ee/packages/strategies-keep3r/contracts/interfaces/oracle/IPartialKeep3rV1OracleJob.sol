// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/jobs/IKeep3rJob.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IKeep3rJob {
  event SetRewardMultiplier(uint256 _rewardMultiplier);

  function rewardMultiplier() external view returns (uint256 _rewardMultiplier);

  function setRewardMultiplier(uint256 _rewardMultiplier) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-ySwaps/hardhat-monorepo-ecc0b5147992b34c315e08af170ceb4a5fe071ee/packages/strategies-keep3r/contracts/interfaces/oracle/IPartialKeep3rV1OracleJob.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IPartialKeep3rV1OracleJob is IKeep3rJob {
  event PairAdded(address _pair);
  event PairRemoved(address _pair);

  // Actions by Keeper
  event Worked(address _pair, address _keeper, uint256 _credits);

  // Actions forced by Governor
  event ForceWorked(address _pair);

  // Setters
  function addPairs(address[] calldata _pairs) external;

  function addPair(address _pair) external;

  function removePair(address _pair) external;

  // Getters
  function oracleBondedKeeper() external view returns (address _oracleBondedKeeper);

  function workable(address _pair) external view returns (bool);

  function pairs() external view returns (address[] memory _pairs);

  // Keeper actions
  function work(address _pair) external returns (uint256 _credits);

  // Mechanics keeper bypass
  function forceWork(address _pair) external;
}
