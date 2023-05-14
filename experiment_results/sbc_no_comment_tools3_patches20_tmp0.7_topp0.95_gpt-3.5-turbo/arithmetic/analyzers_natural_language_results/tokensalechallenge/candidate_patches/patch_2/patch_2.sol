pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    function TokenSaleChallenge() public payable {
        require(msg.value == 1 ether);
        balanceOf[msg.sender] = 1; // initialize balanceOf[msg.sender] to 1 token
    }

    function isComplete() public view returns (bool) {
        return address(this).balance >= 1 ether; // fix return condition
    }

    function buy() public payable {
        uint256 numTokens = msg.value / PRICE_PER_TOKEN; // calculate number of tokens
        balanceOf[msg.sender] += numTokens; // add tokens to balance
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;

        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}