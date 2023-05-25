pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant public PRICE_PER_TOKEN = 1 ether;
    uint256 public totalTokens;

    function TokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
        totalTokens = msg.value / PRICE_PER_TOKEN;
        balanceOf[_player] = totalTokens;
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= totalTokens * PRICE_PER_TOKEN;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        balanceOf[msg.sender] += numTokens;
        totalTokens += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);
        balanceOf[msg.sender] -= numTokens;
        totalTokens -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}