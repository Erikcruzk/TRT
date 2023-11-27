pragma solidity ^0.4.24;

contract Lotto {

uint constant public blocksPerRound = 6800;
uint constant public ticketPrice = 100000000000000000;
uint constant public blockReward = 5000000000000000000;

function getBlocksPerRound() public pure returns(uint) {
return blocksPerRound;
}

function getTicketPrice() public pure returns(uint) {
return ticketPrice;
}

struct Round {
address[] buyers;
uint pot;
uint ticketsCount;
mapping(uint=>bool) isCashed;
mapping(address=>uint) ticketsCountByBuyer;
}

mapping(uint => Round) rounds;

function getRoundIndex() public view returns (uint) {
return block.number/blocksPerRound;
}

function getIsCashed(uint roundIndex,uint subpotIndex) public view returns (bool) {
return rounds[roundIndex].isCashed[subpotIndex];
}

function calculateWinner(uint roundIndex, uint subpotIndex) public view returns(address) {
require(subpotIndex < getSubpotsCount(roundIndex), "Invalid subpot index");
uint decisionBlockNumber = getDecisionBlockNumber(roundIndex,subpotIndex);
require(decisionBlockNumber <= block.number, "Decision block not yet reached");
bytes32 decisionBlockHash = blockhash(decisionBlockNumber);
require(decisionBlockHash != 0, "Blockhash not available");
uint winningTicketIndex = uint(decisionBlockHash) % rounds[roundIndex].ticketsCount;
uint ticketIndex = 0;
for(uint i = 0; i < rounds[roundIndex].buyers.length; i++){
address buyer = rounds[roundIndex].buyers[i];
ticketIndex += rounds[roundIndex].ticketsCountByBuyer[buyer];
if(ticketIndex > winningTicketIndex){
return buyer;
}
}
}

function getDecisionBlockNumber(uint roundIndex,uint subpotIndex) public pure returns (uint) {
return ((roundIndex+1)*blocksPerRound)+subpotIndex;
}

function getSubpotsCount(uint roundIndex) public view returns(uint) {
uint subpotsCount = rounds[roundIndex].pot/blockReward;
if(rounds[roundIndex].pot%blockReward > 0) {
subpotsCount++;
}
return subpotsCount;
}

function getSubpot(uint roundIndex) public view returns(uint) {
return rounds[roundIndex].pot/getSubpotsCount(roundIndex);
}

function cash(uint roundIndex, uint subpotIndex) public {
require(subpotIndex < getSubpotsCount(roundIndex), "Invalid subpot index");
require(!rounds[roundIndex].isCashed[subpotIndex], "Subpot already cashed");
address winner = calculateWinner(roundIndex,subpotIndex);
uint subpot = getSubpot(roundIndex);
require(winner != address(0), "Winner not found");
require(winner.send(subpot), "Failed to send subpot to winner");
rounds[roundIndex].isCashed[subpotIndex] = true;
}

function getBuyers(uint roundIndex,address buyer) public view returns (address[]) {
return rounds[roundIndex].buyers;
}

function getTicketsCountByBuyer(uint roundIndex,address buyer) public view returns (uint) {
return rounds[roundIndex].ticketsCountByBuyer[buyer];
}

function getPot(uint roundIndex) public view returns(uint) {
return rounds[roundIndex].pot;
}

function() public payable {
uint roundIndex = getRoundIndex();
uint value = msg.value - (msg.value % ticketPrice);
if(value == 0) {
if(msg.value > 0) {
msg.sender.transfer(msg.value);
}
return;
}
if(value < msg.value) {
msg.sender.transfer(msg.value - value);
}
uint ticketsCount = value / ticketPrice;
rounds[roundIndex].ticketsCount += ticketsCount;
if(rounds[roundIndex].ticketsCountByBuyer[msg.sender] == 0) {
rounds[roundIndex].buyers.push(msg.sender);
}
rounds[roundIndex].ticketsCountByBuyer[msg.sender] += ticketsCount;
rounds[roundIndex].pot += value;
}
}