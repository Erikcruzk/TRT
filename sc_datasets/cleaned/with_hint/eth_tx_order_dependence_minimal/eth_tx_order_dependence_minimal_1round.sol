pragma solidity ^0.4.16;

library SafeMath {
function add(uint256 a, uint256 b) internal pure returns (uint256) {
uint256 c = a + b;
require(c >= a);
return c;
}
}

contract EthTxOrderDependenceMinimal {
using SafeMath for uint256;

address public owner;
bool public claimed;
uint256 public reward;

function EthTxOrderDependenceMinimal() public {
owner = msg.sender;
}

function setReward() public payable {
require(!claimed);
require(msg.sender == owner);

uint256 oldReward = reward;
reward = msg.value;
owner.transfer(oldReward);
}

function claimReward(uint256 submission) public {
require(!claimed);
require(submission < 10);
require(reward > 0);

uint256 amount = reward;
reward = 0;
claimed = true;
msg.sender.transfer(amount);
}
}