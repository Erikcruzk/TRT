pragma solidity ^0.4.16;

contract EthTxOrderDependenceMinimal {
address public owner;
bool public claimed;
uint public reward;

function EthTxOrderDependenceMinimal() public {
owner = msg.sender;
}

function setReward() public payable {
require(!claimed);
require(msg.sender == owner);

reward = msg.value;
claimed = false;
owner.transfer(reward);
}

function claimReward(uint256 submission) public {
require(!claimed);
require(submission < 10);
require(reward > 0);

msg.sender.transfer(reward);
claimed = true;
}
}