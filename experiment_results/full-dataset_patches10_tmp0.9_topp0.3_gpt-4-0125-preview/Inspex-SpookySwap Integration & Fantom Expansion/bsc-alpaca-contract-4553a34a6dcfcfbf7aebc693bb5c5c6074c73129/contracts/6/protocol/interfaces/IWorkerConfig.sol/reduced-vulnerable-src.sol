














pragma solidity 0.6.6;

interface IWorkerConfig {
  
  function acceptDebt(address worker) external view returns (bool);

  
  function workFactor(address worker, uint256 debt) external view returns (uint256);

  
  function killFactor(address worker, uint256 debt) external view returns (uint256);

  
  function rawKillFactor(address worker, uint256 debt) external view returns (uint256);

  
  function isStable(address worker) external view returns (bool);

  
  function isReserveConsistent(address worker) external view returns (bool);
}