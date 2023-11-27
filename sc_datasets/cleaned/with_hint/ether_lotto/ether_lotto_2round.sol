pragma solidity ^0.4.26;

contract EtherLotto {

uint constant TICKET_AMOUNT = 10;
uint constant FEE_AMOUNT = 1;
address public bank;
uint public pot;

constructor() public {
bank = msg.sender;
}

function play() public payable {
require(msg.value == TICKET_AMOUNT);
pot += msg.value;
uint random = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 2;
if (random == 0) {
bank.transfer(FEE_AMOUNT);
msg.sender.transfer(pot - FEE_AMOUNT);
pot = 0;
}
}
}