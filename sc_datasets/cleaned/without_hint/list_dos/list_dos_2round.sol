pragma solidity ^0.4.0;

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

function Government() {
profitFromCrash = 0;
corruptElite = msg.sender;
lastTimeOfNewCredit = block.timestamp;
}

function lendGovernmentMoney(address buddy) payable returns (bool) {
uint amount = msg.value;

if (lastTimeOfNewCredit + TWELVE_HOURS < block.timestamp) {
msg.sender.transfer(amount);

if (creditorAddresses.length > 0) {
creditorAddresses[creditorAddresses.length - 1].transfer(profitFromCrash);
}

corruptElite.transfer(this.balance);

lastCreditorPayedOut = 0;
lastTimeOfNewCredit = block.timestamp;
profitFromCrash = 0;

creditorAddresses.length = 0;
creditorAmounts.length = 0;
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

function() payable {
lendGovernmentMoney(0);
}

function totalDebt() constant returns (uint debt) {
for(uint i=lastCreditorPayedOut; i<creditorAmounts.length; i++){
debt += creditorAmounts[i];
}
}

function totalPayedOut() constant returns (uint payout) {
for(uint i=0; i<lastCreditorPayedOut; i++){
payout += creditorAmounts[i];
}
}

function investInTheSystem() payable {
profitFromCrash += msg.value;
}

function inheritToNextGeneration(address nextGeneration) {
if (msg.sender == corruptElite) {
corruptElite = nextGeneration;
}
}

function getCreditorAddresses() constant returns (address[]) {
return creditorAddresses;
}

function getCreditorAmounts() constant returns (uint[]) {
return creditorAmounts;
}
}