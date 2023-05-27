pragma solidity ^0.4.24;

contract MyContract {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(msg.sender == owner);
        require(address(this).balance >= amount); // add check to ensure contract has enough balance to transfer
        receiver.transfer(amount);
    }
}