pragma solidity ^0.4.16;

import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

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
require(reward > 0);
require(submission < 10);

uint256 amount = reward;
claimed = true;
reward = 0;
msg.sender.transfer(amount);
}
}