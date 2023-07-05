// File: ../sc_datasets/DAppSCAN/Byterocket-AsyncArt v2[05.26.2020]/async-contracts-1bbca6bfe1a171f1bb8369ff129d5aac234a6664/contracts/Migrations.sol

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
