pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);
        require(winner != 0x0);

        bool success = winner.send(winAmount);
        require(success);

        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        bool success = msg.sender.send(this.balance);
        require(success);
    }
}