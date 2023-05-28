pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0)); // Check if winner address is not null
        require(winner.send(winAmount)); // Check the return value of send() function
        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender.send(this.balance)); // Check the return value of send() function
    }
}