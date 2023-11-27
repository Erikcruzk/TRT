pragma solidity ^0.4.0;

contract Lottery {
event GetBet(uint betAmount, uint blockNumber, bool won);

struct Bet {
uint betAmount;
uint blockNumber;
bool won;
}

address private organizer;
Bet[] private bets;

function Lottery() {
organizer = msg.sender;
}

function() {
revert();
}

function makeBet() payable {
bool won = (block.number % 2) == 0;
bets.push(Bet(msg.value, block.number, won));
if(won) {
if(!msg.sender.send(msg.value)) {
revert();
}
}
}

function getBets() {
require(msg.sender == organizer);
for (uint i = 0; i < bets.length; i++) {
GetBet(bets[i].betAmount, bets[i].blockNumber, bets[i].won);
}
}

function destroy() {
require(msg.sender == organizer);
selfdestruct(organizer);
}
}