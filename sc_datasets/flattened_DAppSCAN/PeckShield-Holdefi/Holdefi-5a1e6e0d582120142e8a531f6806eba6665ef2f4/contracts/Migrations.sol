// File: ../sc_datasets/DAppSCAN/PeckShield-Holdefi/Holdefi-5a1e6e0d582120142e8a531f6806eba6665ef2f4/contracts/Migrations.sol

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
