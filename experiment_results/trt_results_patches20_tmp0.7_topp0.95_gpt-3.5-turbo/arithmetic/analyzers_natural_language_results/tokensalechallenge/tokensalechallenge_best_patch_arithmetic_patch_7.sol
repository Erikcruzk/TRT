pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 public constant PRICE_PER_TOKEN = 1 ether;
    uint256 public constant MAX_TOKENS = 100;

    function TokenSaleChallenge() public payable {
        require(msg.value == MAX_TOKENS * PRICE_PER_TOKEN);
        balanceOf[msg.sender] = MAX_TOKENS;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= MAX_TOKENS * PRICE_PER_TOKEN;
    }

    function buy(uint256 numTokens) public payable {
        require(numTokens <= MAX_TOKENS && balanceOf[msg.sender] + numTokens <= MAX_TOKENS);
        require(msg.value == numTokens * PRICE_PER_TOKEN);

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);
        require(address(this).balance >= numTokens * PRICE_PER_TOKEN);

        balanceOf[msg.sender] -= numTokens;

        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}