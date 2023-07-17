// File: ../sc_datasets/DAppSCAN/Coinfabrik-DreamTeam Smart Contracts Audit for Players Compensation/smart-contracts-c1efcabf8a56a4d0a1fa5185a095052c110bdd87/contracts/storage/BasicStorage.sol

pragma solidity ^0.4.18;

contract BasicStorage {

    mapping(address => bool) public owners; // Database owners, addresses that have permissions to write data to DB

    modifier ownersOnly {require(owners[msg.sender]); _;}

    function BasicStorage (address[] initialOwners) public {
        for (uint i; i < initialOwners.length; i++) {
            owners[initialOwners[i]] = true;
        }
    }

    function transferOwnership (address newOwner) public ownersOnly {
        owners[newOwner] = true;
        delete owners[msg.sender];
    }

    function grantAccess (address newOwner) public ownersOnly {
        owners[newOwner] = true;
    }

    function revokeAccess (address previousOwner) public ownersOnly {
        delete owners[previousOwner];
    }

    function isOwner (address addr) public view returns(bool) {
        return owners[addr] == true;
    }

}
