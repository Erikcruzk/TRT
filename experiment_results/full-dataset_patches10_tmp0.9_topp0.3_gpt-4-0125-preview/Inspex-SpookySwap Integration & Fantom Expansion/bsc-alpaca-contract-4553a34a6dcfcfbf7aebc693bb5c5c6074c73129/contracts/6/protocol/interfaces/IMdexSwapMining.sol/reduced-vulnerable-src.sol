














pragma solidity 0.6.6;

interface IMdexSwapMining {
  
  function getUserReward(uint256 pid) external view returns (uint256, uint256);

  
  function takerWithdraw() external;
}