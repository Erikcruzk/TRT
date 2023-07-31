// File: ../sc_datasets/DAppSCAN/ConsenSys Diligence-Modular Interactive Crowdsale/ethereum-libraries-73abc22623e0841b8ea67a5089002f4867102672/CrowdsaleLib/DirectCrowdsale/truffle/contracts/Migrations.sol

pragma solidity ^0.4.13;

contract Migrations {
  address public owner;
  uint public last_completed_migration;

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function Migrations() {
    owner = msg.sender;
  }

  function setCompleted(uint completed) restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
