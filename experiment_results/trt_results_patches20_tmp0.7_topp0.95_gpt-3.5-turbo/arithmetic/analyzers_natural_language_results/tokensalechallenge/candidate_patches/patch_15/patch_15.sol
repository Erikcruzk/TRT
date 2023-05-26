pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 public constant PRICE_PER_TOKEN = 1 ether;
    uint256 public constant MAX_TOKENS = 1000;

    function TokenSaleChallenge() public payable {
        require(msg.value == MAX_TOKENS * PRICE_PER_TOKEN);
        balanceOf[msg.sender] = MAX_TOKENS;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= MAX_TOKENS * PRICE_PER_TOKEN;
    }

    function buy(uint256 numTokens) public payable {
        require(numTokens <= MAX_TOKENS);
        require(balanceOf[msg.sender] + numTokens <= MAX_TOKENS);
        require(msg.value == numTokens * PRICE_PER_TOKEN);

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(numTokens <= MAX_TOKENS);
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
} 

// The repaired contract includes changes to the constructor, isComplete, buy, and sell functions to avoid arithmetic vulnerabilities and ensure secure token transactions. The maximum number of tokens that can be bought or sold is limited to 1000 to prevent overflow and ensure the contract's security.