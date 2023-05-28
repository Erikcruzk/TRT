pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    function TokenSaleChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN && numTokens > 0);

        uint256 totalCost = numTokens * PRICE_PER_TOKEN;
        require(totalCost / numTokens == PRICE_PER_TOKEN);

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens && numTokens > 0);

        balanceOf[msg.sender] -= numTokens;

        uint256 totalCost = numTokens * PRICE_PER_TOKEN;
        require(totalCost / numTokens == PRICE_PER_TOKEN);

        msg.sender.transfer(totalCost);
    }
}