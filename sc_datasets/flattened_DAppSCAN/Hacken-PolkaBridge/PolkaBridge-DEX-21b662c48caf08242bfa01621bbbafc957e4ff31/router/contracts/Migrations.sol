// File: ../sc_datasets/DAppSCAN/Hacken-PolkaBridge/PolkaBridge-DEX-21b662c48caf08242bfa01621bbbafc957e4ff31/router/contracts/Migrations.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  constructor() public {
    owner = msg.sender;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
