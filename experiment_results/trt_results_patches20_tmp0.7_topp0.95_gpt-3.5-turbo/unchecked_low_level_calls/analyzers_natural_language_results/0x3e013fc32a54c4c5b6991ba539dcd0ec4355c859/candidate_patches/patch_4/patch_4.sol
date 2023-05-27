pragma solidity ^0.4.18;

contract MultiplicatorX4 {
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

    function multiplicate(address _to) public payable {
        require(msg.value > 0);
        _to.transfer(msg.value * 4);
    }
}