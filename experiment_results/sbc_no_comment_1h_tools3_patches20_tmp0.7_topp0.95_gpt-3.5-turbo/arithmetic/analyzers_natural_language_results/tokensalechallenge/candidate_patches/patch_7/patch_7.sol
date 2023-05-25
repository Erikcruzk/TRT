pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant public PRICE_PER_TOKEN = 1 ether;

    function TokenSaleChallenge() public payable {
        require(msg.value == 1 ether);
        balanceOf[msg.sender] = 0;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        require(numTokens > 0);

        uint256 tokensToBuy = numTokens;
        uint256 totalPrice = tokensToBuy * PRICE_PER_TOKEN;

        require(totalPrice / tokensToBuy == PRICE_PER_TOKEN);

        balanceOf[msg.sender] += tokensToBuy;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);
        require(numTokens > 0);

        uint256 tokensToSell = numTokens;
        uint256 totalValue = tokensToSell * PRICE_PER_TOKEN;

        balanceOf[msg.sender] -= tokensToSell;

        require(this.balance >= totalValue);

        msg.sender.transfer(totalValue);
    }
}