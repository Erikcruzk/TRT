pragma solidity ^0.8.0;

contract MyContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function sendTo(address payable receiver, uint amount) public {
        require(msg.sender == owner, "Only contract owner can send ether.");
        receiver.transfer(amount);
    }
}