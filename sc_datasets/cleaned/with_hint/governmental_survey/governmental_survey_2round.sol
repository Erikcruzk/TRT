pragma solidity ^0.4.0;

contract Governmental {
address public owner;
address public lastInvestor;
uint public jackpot = 1 ether;
uint public lastInvestmentTimestamp;
uint public ONE_MINUTE = 1 minutes;

function Governmental() public payable {
owner = msg.sender;
require(msg.value >= 1 ether);
}

function invest() public payable {
require(msg.value >= jackpot/2);
lastInvestor = msg.sender;
jackpot += msg.value/2;
lastInvestmentTimestamp = block.timestamp;
}

function resetInvestment() public {
require(block.timestamp >= lastInvestmentTimestamp+ONE_MINUTE);
require(lastInvestor != address(0));
uint payout = jackpot;
jackpot = 1 ether;
lastInvestmentTimestamp = 0;
lastInvestor.transfer(payout);
owner.transfer(address(this).balance);
}
}

contract Attacker {
function attack(address target, uint count) public {
require(count >= 1023);
Governmental(target).resetInvestment();
}
}