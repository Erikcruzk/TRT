pragma solidity ^0.4.0;

contract SimpleSuicide {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function suicideOwner() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}