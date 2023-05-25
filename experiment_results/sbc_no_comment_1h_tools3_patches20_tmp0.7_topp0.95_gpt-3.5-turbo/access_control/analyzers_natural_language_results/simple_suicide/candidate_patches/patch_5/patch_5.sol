pragma solidity ^0.4.0;

contract SimpleSuicide {
    address owner;

    function SimpleSuicide() public {
        owner = msg.sender;
    }

    function suicideOwner() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}