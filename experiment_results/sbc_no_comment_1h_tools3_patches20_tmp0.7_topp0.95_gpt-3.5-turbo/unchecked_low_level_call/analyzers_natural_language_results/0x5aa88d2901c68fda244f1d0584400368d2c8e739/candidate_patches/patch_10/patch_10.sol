pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _to, bytes _data) public payable {
        require(msg.sender == owner);
        require(_to.call.value(msg.value)(_data));
    }

    function multiply(address _to) public payable {
        require(msg.value > 0);
        require(_to != address(0));
        _to.transfer(msg.value * 3);
    }
}