pragma solidity ^0.4.0;

contract SimpleSuicide {
    address owner;

    function SimpleSuicide() {
        owner = msg.sender;
    }

    function suicideOwner() {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
} 

// This repaired Solidity Smart Contract adds an owner variable and a modifier to restrict the self-destruct function to only be called by the owner of the contract. This fixes the vulnerability identified by Mythril.