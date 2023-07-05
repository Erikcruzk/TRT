// File: ../sc_datasets/DAppSCAN/openzeppelin-WeTrust_ROSCA_contract_code/rosca-contracts-2af29be97d529488f5488fe0592f9e6b3585254f/contracts/Migrations.sol

pragma solidity ^0.4.4;

contract Migrations {
  address public owner;

  // A function with the signature `last_completed_migration()`, returning a uint, is required.
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function Migrations() {
    owner = msg.sender;
  }

  // A function with the signature `setCompleted(uint)` is required.
  function setCompleted(uint completed) restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
