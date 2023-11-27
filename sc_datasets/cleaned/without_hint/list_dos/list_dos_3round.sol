pragma solidity ^0.4.26;

contract Government {

uint32 public lastCreditorPayedOut;
uint public lastTimeOfNewCredit;
uint public profitFromCrash;
address[] public creditorAddresses;
uint[] public creditorAmounts;
address public corruptElite;
mapping (address => uint) buddies;
uint constant TWELVE_HOURS = 43200;
uint8 public round;

constructor() public payable {
profitFromCrash = msg.value;
corruptElite = msg.sender;
lastTimeOfNewCredit = block.timestamp;
}

function lendGovernmentMoney(address buddy) public payable returns (bool) {
uint amount = msg.value;

if (lastTimeOfNewCredit + TWELVE_HOURS < block.timestamp) {
msg.sender.transfer(amount);

creditorAddresses[creditorAddresses.length - 1].transfer(profitFromCrash);
corruptElite.transfer(address(this).balance);

lastCreditorPayedOut = 0;
lastTimeOfNewCredit = block.timestamp;
profitFromCrash = 0;

creditorAddresses = new address[](0);
creditorAmounts = new uint[](0);
round += 1;
return false;
}
else {
if (amount >= 10 ** 18) {
lastTimeOfNewCredit = block.timestamp;

creditorAddresses.push(msg.sender);
creditorAmounts.push(amount * 110 / 100);

corruptElite.transfer(amount * 5/100);

if (profitFromCrash < 10000 * 10**18) {
profitFromCrash += amount * 5/100;
}

if(buddies[buddy] >= amount) {
buddy.transfer(amount * 5/100);
}
buddies[msg.sender] += amount * 110 / 100;

if (creditorAmounts[lastCreditorPayedOut] <= address(this).balance - profitFromCrash) {
creditorAddresses[lastCreditorPayedOut].transfer(creditorAmounts[lastCreditorPayedOut]);
buddies[creditorAddresses[lastCreditorPayedOut]] -= creditorAmounts[lastCreditorPayedOut];
lastCreditorPayedOut += 1;
}
return true;
}
else {
msg.sender.transfer(amount);
return false;
}
}
}

function() public {
lendGovernmentMoney(0);
}

function totalDebt() public view returns (uint debt) {
for(uint i=lastCreditorPayedOut; i<creditorAmounts.length; i++){
debt += creditorAmounts[i];
}
}

function totalPayedOut() public view returns (uint payout) {
for(uint i=0; i<lastCreditorPayedOut; i++){
payout += creditorAmounts[i];
}
}

function investInTheSystem() public payable {
profitFromCrash += msg.value;
}

function inheritToNextGeneration(address nextGeneration) public {
require(msg.sender == corruptElite, "Only corruptElite can call this function.");
corruptElite = nextGeneration;
}

function getCreditorAddresses() public view returns (address[]) {
return creditorAddresses;
}

function getCreditorAmounts() public view returns (uint[]) {
return creditorAmounts;
}
}