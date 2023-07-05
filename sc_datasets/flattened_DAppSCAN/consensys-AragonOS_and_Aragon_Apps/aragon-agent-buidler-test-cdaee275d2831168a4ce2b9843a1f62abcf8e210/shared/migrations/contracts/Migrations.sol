// File: ../sc_datasets/DAppSCAN/consensys-AragonOS_and_Aragon_Apps/aragon-agent-buidler-test-cdaee275d2831168a4ce2b9843a1f62abcf8e210/shared/migrations/contracts/Migrations.sol

pragma solidity ^0.4.2;


contract Migrations {
    address public owner;
    uint public lastCompletedMigration;

    modifier restricted() {
        if (msg.sender == owner)
            _;
    }

    constructor()  public {
        owner = msg.sender;
    }

    function setCompleted(uint completed) restricted public {
        lastCompletedMigration = completed;
    }

    function upgrade(address newAddress) restricted public {
        Migrations upgraded = Migrations(newAddress);
        upgraded.setCompleted(lastCompletedMigration);
    }
}
