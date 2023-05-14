pragma solidity ^0.4.0;

contract SimpleSuicide {
    address owner;

    function SimpleSuicide() {
        owner = msg.sender;
    }

    function sudicideAnyone(address target) {
        require(msg.sender == owner);
        selfdestruct(target);
    }
}