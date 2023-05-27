pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0)); // Added check to ensure winner address is not 0x0

        bool success = winner.send(winAmount);
        require(success); // Added check to ensure send was successful

        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != address(0)); // Added check to ensure sender address is not 0x0

        bool success = msg.sender.send(this.balance);
        require(success); // Added check to ensure send was successful
    }
}