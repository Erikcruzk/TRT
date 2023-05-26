pragma solidity ^0.8.0;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor() payable {
        require(msg.value == 1 ether, "Amount should be exactly 1 ether");
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN, "Invalid amount");

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens, "Insufficient balance");

        balanceOf[msg.sender] -= numTokens;

        uint256 amount = numTokens * PRICE_PER_TOKEN;
        require(address(this).balance >= amount, "Contract balance is low");
        payable(msg.sender).transfer(amount);
    }
}