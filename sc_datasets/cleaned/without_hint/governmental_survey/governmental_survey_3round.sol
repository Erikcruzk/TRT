pragma solidity ^0.4.0;

contract Governmental {
address public owner;
address public lastInvestor;
uint public jackpot = 1 ether;
uint public lastInvestmentTimestamp;
uint public ONE_MINUTE = 1 minutes;
bool public investmentInProgress;

function Governmental() {
owner = msg.sender;
if (msg.value<1 ether) throw;
}

function invest() {
if (msg.value<jackpot/2) throw;
lastInvestor = msg.sender;
jackpot += msg.value/2;
lastInvestmentTimestamp = block.timestamp;
investmentInProgress = true;
}

function resetInvestment() {
require(investmentInProgress == true);
require(block.timestamp >= lastInvestmentTimestamp+ONE_MINUTE);

lastInvestor.transfer(jackpot);
owner.transfer(this.balance-1 ether);

lastInvestor = 0;
jackpot = 1 ether;
lastInvestmentTimestamp = 0;
investmentInProgress = false;
}
}