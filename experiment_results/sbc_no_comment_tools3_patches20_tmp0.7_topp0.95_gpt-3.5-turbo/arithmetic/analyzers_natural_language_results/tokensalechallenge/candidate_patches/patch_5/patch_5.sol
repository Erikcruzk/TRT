pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;
    uint256 public tokensSold;
    address public owner;

    function TokenSaleChallenge() public {
        owner = msg.sender;
    }

    function isComplete() public view returns (bool) {
        return tokensSold >= 1 ether/PRICE_PER_TOKEN;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);
        balanceOf[msg.sender] += numTokens;
        tokensSold += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);
        balanceOf[msg.sender] -= numTokens;
        tokensSold -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}