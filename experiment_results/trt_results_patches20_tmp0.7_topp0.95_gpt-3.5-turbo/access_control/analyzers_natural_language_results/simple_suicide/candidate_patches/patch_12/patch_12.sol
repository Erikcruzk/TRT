pragma solidity ^0.4.0;

contract SimpleSuicide {
    address owner;
    
    function SimpleSuicide() {
        owner = msg.sender;
    }
    
    function suicide() {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
}