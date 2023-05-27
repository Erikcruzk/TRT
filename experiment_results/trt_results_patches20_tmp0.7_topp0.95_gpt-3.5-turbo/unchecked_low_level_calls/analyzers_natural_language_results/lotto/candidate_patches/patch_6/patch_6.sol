pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != 0x0);
        require(winner.send(winAmount));
        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != 0x0);
        require(msg.sender.send(this.balance));
    }
}