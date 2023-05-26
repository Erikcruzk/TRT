pragma solidity ^0.8.0;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor() payable {}

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN, "Incorrect value sent.");

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens, "Insufficient tokens.");

        balanceOf[msg.sender] -= numTokens;

        require(msg.sender.send(numTokens * PRICE_PER_TOKEN), "Transaction failed.");
    }
}