pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0)); // check if winner address is valid before sending funds
        require(winAmount > 0); // check if winAmount is greater than 0 before sending funds

        payedOut = true;
        winner.transfer(winAmount); // use transfer instead of send to handle failed transactions
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != address(0)); // check if sender address is valid before sending funds

        msg.sender.transfer(this.balance); // use transfer instead of send to handle failed transactions
    }
}