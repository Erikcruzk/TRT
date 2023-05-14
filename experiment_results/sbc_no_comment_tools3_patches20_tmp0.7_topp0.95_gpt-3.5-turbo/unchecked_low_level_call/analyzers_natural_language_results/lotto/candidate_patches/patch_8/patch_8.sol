pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0)); // check if winner address is valid

        bool success = winner.send(winAmount); // check if the send transaction was successful
        require(success);

        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != address(0)); // check if sender address is valid

        bool success = msg.sender.send(this.balance); // check if the send transaction was successful
        require(success);
    }
}