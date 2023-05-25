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
        require(msg.value == numTokens * PRICE_PER_TOKEN && msg.value > 0);

        uint256 newBalance = balanceOf[msg.sender] + numTokens;
        require(newBalance > balanceOf[msg.sender]);

        balanceOf[msg.sender] = newBalance;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        uint256 saleValue = numTokens * PRICE_PER_TOKEN;
        require(saleValue > 0);

        balanceOf[msg.sender] -= numTokens;

        msg.sender.transfer(saleValue);
    }
}