// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/interfaces/IVaultFarm.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IVaultFarm {
  function syncDeposit(address _user, uint256 _amount, address asset) external;
  function syncWithdraw(address _user, uint256 _amount, address asset) external;
  function syncLiquidate(address _user, address asset) external;

}
