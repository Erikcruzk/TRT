pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant public PRICE_PER_TOKEN = 1 ether;
    uint256 public totalTokens;

    function TokenSaleChallenge() public {
        totalTokens = 1000;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= totalTokens * PRICE_PER_TOKEN;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        require(totalTokens >= numTokens);

        balanceOf[msg.sender] += numTokens;
        totalTokens -= numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        totalTokens += numTokens;

        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}