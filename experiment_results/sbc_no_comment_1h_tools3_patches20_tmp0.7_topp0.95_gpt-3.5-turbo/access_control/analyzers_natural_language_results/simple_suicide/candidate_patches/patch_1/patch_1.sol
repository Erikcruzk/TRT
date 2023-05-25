pragma solidity ^0.4.0;

contract SimpleSuicide {
    address owner;

    function SimpleSuicide() public {
        owner = msg.sender;
    }

    function sudicideAnyone(address _recipient) public {
        require(msg.sender == owner);
        selfdestruct(_recipient);
    }
}