pragma solidity ^0.4.24;

contract MyContract {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(msg.sender == owner);
        require(amount <= address(this).balance); // check contract balance
        receiver.transfer(amount);
    }
}