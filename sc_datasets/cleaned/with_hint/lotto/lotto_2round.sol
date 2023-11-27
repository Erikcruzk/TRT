pragma solidity ^0.4.18;

contract Lotto {

bool public payedOut = false;
address public winner;
uint public winAmount;

function sendToWinner() public {
require(!payedOut && winner != address(0) && winAmount > 0);

payedOut = true;
winner.transfer(winAmount);
}

function withdrawLeftOver() public {
require(payedOut);

msg.sender.transfer(this.balance);
}
}