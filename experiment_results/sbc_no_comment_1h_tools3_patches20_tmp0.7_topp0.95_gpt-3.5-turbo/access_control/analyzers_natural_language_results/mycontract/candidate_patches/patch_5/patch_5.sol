pragma solidity ^0.4.24;

contract MyContract {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(msg.sender == owner);
        receiver.transfer(amount);
    }
}