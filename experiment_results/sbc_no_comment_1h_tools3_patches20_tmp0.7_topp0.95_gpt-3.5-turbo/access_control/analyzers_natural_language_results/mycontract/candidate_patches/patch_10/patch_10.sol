pragma solidity ^0.6.0;

contract MyContract {
    address payable owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address payable receiver, uint amount) public {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        receiver.transfer(amount);
    }
}