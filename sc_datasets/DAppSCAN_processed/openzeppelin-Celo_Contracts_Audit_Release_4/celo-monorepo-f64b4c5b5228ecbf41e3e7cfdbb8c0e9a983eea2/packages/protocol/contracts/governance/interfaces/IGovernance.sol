// File: ../sc_datasets/DAppSCAN/openzeppelin-Celo_Contracts_Audit_Release_4/celo-monorepo-f64b4c5b5228ecbf41e3e7cfdbb8c0e9a983eea2/packages/protocol/contracts/governance/interfaces/IGovernance.sol

pragma solidity ^0.5.13;

interface IGovernance {
  function isVoting(address) external view returns (bool);
}