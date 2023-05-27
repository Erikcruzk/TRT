pragma solidity ^0.4.24;

contract OddsAndEvens {
    struct Player {
        address addr;
        uint number;
    }

    Player[2] public players;

    uint8 tot;
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function play(uint number) public payable {
        require(msg.value == 1 ether, "Please send 1 ether to play.");
        require(tot < 2, "Game is full.");

        players[tot] = Player(msg.sender, number);
        tot++;

        if (tot == 2) {
            andTheWinnerIs();
        }
    }

    function andTheWinnerIs() private {
        uint n = players[0].number + players[1].number;
        if (n % 2 == 0) {
            require(players[0].addr.send(1800 finney), "Failed to send winnings to player 1.");
        } else {
            require(players[1].addr.send(1800 finney), "Failed to send winnings to player 2.");
        }

        delete players;
        tot = 0;
    }

    function getProfit() public {
        require(msg.sender == owner, "Only the owner can call this function.");
        require(address(this).balance > 0, "No balance to withdraw.");

        require(owner.send(address(this).balance), "Failed to send profit to owner.");
    }
}