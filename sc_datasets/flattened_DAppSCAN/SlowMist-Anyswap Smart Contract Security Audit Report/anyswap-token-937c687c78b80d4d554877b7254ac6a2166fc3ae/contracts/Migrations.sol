// File: ../sc_datasets/DAppSCAN/SlowMist-Anyswap Smart Contract Security Audit Report/anyswap-token-937c687c78b80d4d554877b7254ac6a2166fc3ae/contracts/Migrations.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  constructor() public {
    owner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
