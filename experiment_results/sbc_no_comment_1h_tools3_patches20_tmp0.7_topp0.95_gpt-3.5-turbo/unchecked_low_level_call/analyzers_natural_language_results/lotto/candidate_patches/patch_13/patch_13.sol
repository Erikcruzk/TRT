pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0)); // Ensure winner address is not empty
        require(winAmount > 0); // Ensure win amount is greater than 0

        bool sent = winner.send(winAmount);
        require(sent); // Check if send was successful

        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != address(0)); // Ensure sender address is not empty
        bool sent = msg.sender.send(this.balance);
        require(sent); // Check if send was successful
    }
}