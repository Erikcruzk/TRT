// File: ../sc_datasets/DAppSCAN/Blockchain Labs NZ-Zipper/zipt_token-0a3c4238353122cfc76b9fb01cd60b28b8b0c9e4/contracts/Migrations.sol

pragma solidity ^0.4.17;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function Migrations() public {
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