// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_polynetwork_v2.0/eth-contracts-2b1cbe073e40a7bd26022d1cda9341b4780d07ee/contracts/Migrations.sol

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
