// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit – Send (SDT) Token Sale ICO Smart Contract/sdt-contracts-master/contracts/Migrations.sol

pragma solidity ^0.4.4;


contract Migrations {
    address public owner;
    uint public lastCompletedMigration;

    modifier restricted() {
        if (msg.sender == owner) {
            _;
        }
    }

    function Migrations() public {
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
