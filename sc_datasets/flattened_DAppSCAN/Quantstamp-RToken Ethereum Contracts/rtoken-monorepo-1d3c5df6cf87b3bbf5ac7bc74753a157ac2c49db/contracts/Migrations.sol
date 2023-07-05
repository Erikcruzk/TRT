// File: ../sc_datasets/DAppSCAN/Quantstamp-RToken Ethereum Contracts/rtoken-monorepo-1d3c5df6cf87b3bbf5ac7bc74753a157ac2c49db/contracts/Migrations.sol

pragma solidity >=0.4.21 <0.6.0;

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

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }
}
