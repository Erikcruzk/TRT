pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0));
        require(winAmount > 0);

        bool success = winner.send(winAmount);
        require(success);

        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != address(0));

        msg.sender.transfer(this.balance);
    }
}