pragma solidity ^0.8.0;

contract MyContract {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function sendTo(address payable receiver, uint amount) public {
        require(msg.sender == owner, "Only the owner can send funds");
        receiver.transfer(amount);
    }
}