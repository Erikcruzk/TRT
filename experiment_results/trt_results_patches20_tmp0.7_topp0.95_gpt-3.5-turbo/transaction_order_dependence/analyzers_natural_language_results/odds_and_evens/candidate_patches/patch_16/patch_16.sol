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
        require(msg.value == 1 ether);

        players[tot] = Player(msg.sender, number);
        tot++;

        if (tot == 2) {
            andTheWinnerIs();
        }
    }

    function andTheWinnerIs() private {
        uint n = players[0].number + players[1].number;
        if (n % 2 == 0) {
            players[0].addr.transfer(1800 finney);
        } else {
            players[1].addr.transfer(1800 finney);
        }

        delete players;
        tot = 0;
    }

    function getProfit() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }
}