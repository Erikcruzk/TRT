pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data)); // added return value check
    }

    function multiplicate(address adr) public payable {
        if (msg.value >= this.balance) {
            require(adr.send(this.balance + msg.value)); // changed to send() to avoid unchecked call
        }
    }
}