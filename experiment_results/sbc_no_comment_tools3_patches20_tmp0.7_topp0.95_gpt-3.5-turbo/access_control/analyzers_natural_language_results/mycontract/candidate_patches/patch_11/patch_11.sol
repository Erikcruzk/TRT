pragma solidity ^0.8.0;

contract MyContract {
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function sendTo(address payable receiver, uint amount) public {
        require(msg.sender == owner, "Only owner can call this function");
        receiver.transfer(amount);
    }
}