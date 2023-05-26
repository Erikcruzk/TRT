pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant public PRICE_PER_TOKEN = 1 ether;
    uint256 public totalTokens; // added variable to keep track of total tokens sold
    
    function TokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return totalTokens >= 1 ether; // fixed condition to check total tokens sold
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        balanceOf[msg.sender] += numTokens;
        totalTokens += numTokens; // increment total tokens sold
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);
        balanceOf[msg.sender] -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
        totalTokens -= numTokens; // decrement total tokens sold
    }
}