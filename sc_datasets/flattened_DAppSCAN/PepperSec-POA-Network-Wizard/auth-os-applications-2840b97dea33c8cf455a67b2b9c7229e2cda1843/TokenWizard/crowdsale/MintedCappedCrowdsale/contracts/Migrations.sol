// File: ../sc_datasets/DAppSCAN/PepperSec-POA-Network-Wizard/auth-os-applications-2840b97dea33c8cf455a67b2b9c7229e2cda1843/TokenWizard/crowdsale/MintedCappedCrowdsale/contracts/Migrations.sol

pragma solidity ^0.4.17;

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

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
