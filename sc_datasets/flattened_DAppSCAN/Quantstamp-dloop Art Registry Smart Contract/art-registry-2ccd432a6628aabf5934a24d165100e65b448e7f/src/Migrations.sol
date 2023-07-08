// File: ../sc_datasets/DAppSCAN/Quantstamp-dloop Art Registry Smart Contract/art-registry-2ccd432a6628aabf5934a24d165100e65b448e7f/src/Migrations.sol

pragma solidity >=0.4.21 <0.6.0;

contract Migrations {
    address public owner;
    uint256 public last_completed_migration;

    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    function setCompleted(uint256 completed) public restricted {
        last_completed_migration = completed;
    }

    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
