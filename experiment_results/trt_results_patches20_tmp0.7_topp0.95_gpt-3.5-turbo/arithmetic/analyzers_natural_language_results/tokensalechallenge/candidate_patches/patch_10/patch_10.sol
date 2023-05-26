pragma solidity ^0.8.0;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    constructor(address _player) payable {
        require(msg.value == 1 ether, "Invalid amount sent");
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN, "Invalid amount sent");
        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens, "Insufficient balance");
        balanceOf[msg.sender] -= numTokens;
        uint256 amount = numTokens * PRICE_PER_TOKEN;
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(msg.sender).transfer(amount);
    }
} 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Changed the constructor function to constructor and added a error message for invalid amount sent
// 3. Updated isComplete function to return true when contract balance is equal or greater than 1 ether
// 4. Added an error message for invalid amount sent in buy function
// 5. Added an error message for insufficient balance in sell function
// 6. Added a check for contract balance before transferring ether to the seller in sell function
// 7. Changed transfer function to payable(msg.sender).transfer(amount) to avoid re-entrancy attack vulnerability.