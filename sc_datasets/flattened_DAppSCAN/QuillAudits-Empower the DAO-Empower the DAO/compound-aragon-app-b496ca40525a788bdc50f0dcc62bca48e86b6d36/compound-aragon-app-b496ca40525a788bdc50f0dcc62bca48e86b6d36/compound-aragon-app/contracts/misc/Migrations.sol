// File: ../sc_datasets/DAppSCAN/QuillAudits-Empower the DAO-Empower the DAO/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-aragon-app-b496ca40525a788bdc50f0dcc62bca48e86b6d36/compound-aragon-app/contracts/misc/Migrations.sol

pragma solidity ^0.4.4;


contract Migrations {
    address public owner;
    uint public lastCompletedMigration;

    modifier restricted() {
        if (msg.sender == owner)
            _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function setCompleted(uint completed) public restricted {
        lastCompletedMigration = completed;
    }

    function upgrade(address newAddress) public restricted {
        Migrations upgraded = Migrations(newAddress);
        upgraded.setCompleted(lastCompletedMigration);
    }
}
