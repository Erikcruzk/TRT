pragma solidity ^0.4.21;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    address public owner;
    uint256 public totalTokens;
    uint256 public totalEther;

    event Buy(address indexed buyer, uint256 numTokens);
    event Sell(address indexed seller, uint256 numTokens);

    function TokenSaleChallenge() public {
        owner = msg.sender;
    }

    function isComplete() public view returns (bool) {
        return totalEther >= 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);

        balanceOf[msg.sender] += numTokens;
        totalTokens += numTokens;
        totalEther += msg.value;

        emit Buy(msg.sender, numTokens);
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        totalTokens -= numTokens;
        totalEther -= numTokens * PRICE_PER_TOKEN;

        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);

        emit Sell(msg.sender, numTokens);
    }

    function withdraw() public {
        require(msg.sender == owner);
        require(totalEther >= 1 ether);

        owner.transfer(totalEther);
        totalEther = 0;
    }
}