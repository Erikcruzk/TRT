pragma solidity ^0.4.18;

contract Lotto {
    bool public payedOut = false;
    address public winner;
    uint public winAmount;

    function sendToWinner() public {
        require(!payedOut);

        require(winner != address(0)); // check that winner address is not empty
        
        bool success = winner.send(winAmount);
        require(success); // check that the transfer was successful
        
        payedOut = true;
    }

    function withdrawLeftOver() public {
        require(payedOut);

        require(msg.sender != address(0)); // check that sender address is not empty
        
        bool success = msg.sender.send(this.balance);
        require(success); // check that the transfer was successful
    }
}