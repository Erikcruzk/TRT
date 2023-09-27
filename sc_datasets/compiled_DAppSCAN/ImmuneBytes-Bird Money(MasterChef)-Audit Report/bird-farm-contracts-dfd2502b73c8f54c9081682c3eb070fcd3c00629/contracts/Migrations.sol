// File: ../sc_datasets/DAppSCAN/ImmuneBytes-Bird Money(MasterChef)-Audit Report/bird-farm-contracts-dfd2502b73c8f54c9081682c3eb070fcd3c00629/contracts/Migrations.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}