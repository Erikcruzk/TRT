pragma solidity ^0.8.0;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant public PRICE_PER_TOKEN = 1 ether;

    constructor(address _player) payable {
        require(msg.value == 1 ether, "Incorrect amount of ether sent");
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        uint256 totalCost = numTokens * PRICE_PER_TOKEN;
        require(msg.value == totalCost, "Incorrect amount of ether sent");

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens, "Insufficient token balance");

        balanceOf[msg.sender] -= numTokens;

        uint256 totalCost = numTokens * PRICE_PER_TOKEN;
        require(totalCost <= address(this).balance, "Contract balance is insufficient");

        payable(msg.sender).transfer(totalCost);
    }
}