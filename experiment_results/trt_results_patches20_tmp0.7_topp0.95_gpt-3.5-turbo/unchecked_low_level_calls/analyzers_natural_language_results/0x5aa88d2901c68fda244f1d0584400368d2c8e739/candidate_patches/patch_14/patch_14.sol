pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public Owner;

    function MultiplicatorX3() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }

    function multiplicate(address adr) public payable {
        require(msg.sender == Owner);
        require(msg.value >= this.balance);
        adr.transfer(this.balance + msg.value);
    }
} 

// Changes Made:
// 1. Added a constructor to initialize the Owner address.
// 2. Added a require statement to check the return value of external function calls.
// 3. Added a require statement to check the value of msg.value before transferring funds.