pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    function TokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
        balanceOf[_player] = 0; // initialize balance to 0
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN && numTokens > 0); // check for overflow and require numTokens to be greater than 0

        uint256 totalCost = numTokens * PRICE_PER_TOKEN;
        require(totalCost / numTokens == PRICE_PER_TOKEN); // check for overflow

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens && numTokens > 0); // require numTokens to be greater than 0

        balanceOf[msg.sender] -= numTokens;
        uint256 totalCost = numTokens * PRICE_PER_TOKEN;
        require(totalCost / numTokens == PRICE_PER_TOKEN); // check for overflow

        msg.sender.transfer(totalCost);
    }
}