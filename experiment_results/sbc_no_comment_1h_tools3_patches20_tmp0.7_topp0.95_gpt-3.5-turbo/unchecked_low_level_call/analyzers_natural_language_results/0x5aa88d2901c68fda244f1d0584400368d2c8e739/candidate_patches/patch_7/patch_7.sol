pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

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
        require(msg.value > 0);
        uint256 valueToSend = msg.value * 3;
        require(_target.send(valueToSend));
    }
}