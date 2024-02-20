














pragma solidity 0.6.6;

interface IVaultConfig {
  
  function minDebtSize() external view returns (uint256);

  
  function getInterestRate(uint256 debt, uint256 floating) external view returns (uint256);

  
  function getWrappedNativeAddr() external view returns (address);

  
  function getWNativeRelayer() external view returns (address);

  
  function getFairLaunchAddr() external view returns (address);

  
  function getReservePoolBps() external view returns (uint256);

  
  function getKillBps() external view returns (uint256);

  
  function whitelistedCallers(address caller) external returns (bool);

  
  function whitelistedLiquidators(address caller) external returns (bool);

  
  function approvedAddStrategies(address addStrats) external returns (bool);

  
  function isWorker(address worker) external view returns (bool);

  
  function acceptDebt(address worker) external view returns (bool);

  
  function workFactor(address worker, uint256 debt) external view returns (uint256);

  
  function killFactor(address worker, uint256 debt) external view returns (uint256);

  
  function rawKillFactor(address worker, uint256 debt) external view returns (uint256);

  
  function getKillTreasuryBps() external view returns (uint256);

  
  function getTreasuryAddr() external view returns (address);

  
  function isWorkerStable(address worker) external view returns (bool);

  
  function isWorkerReserveConsistent(address worker) external view returns (bool);
}