pragma solidity ^0.4.24;

contract SimpleSuicide {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function suicideAnyone() public {
        require(msg.sender == owner, "Only the owner can perform this action");
        selfdestruct(owner);
    }
}