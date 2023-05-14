pragma solidity ^0.4.24;

contract SimpleSuicide {
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function suicideOwner() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}