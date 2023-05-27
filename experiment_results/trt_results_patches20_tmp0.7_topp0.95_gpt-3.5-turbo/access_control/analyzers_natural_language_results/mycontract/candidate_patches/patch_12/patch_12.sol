pragma solidity ^0.4.24;

contract MyContract {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(msg.sender == owner);
        require(receiver != address(0));
        receiver.transfer(amount);
    }
}

// Changes Made:
// 1. Changed the constructor name from MyContract to constructor.
// 2. Changed tx.origin to msg.sender for authorization control.
// 3. Added a require statement to check if the receiver address is not 0x0.