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
        bool res;
        uint n = players[0].number + players[1].number;
        if (n % 2 == 0) {
            res = players[0].addr.send(1800 finney);
        } else {
            res = players[1].addr.send(1800 finney);
        }

        delete players;
        tot = 0;
    }

    function getProfit() public {
        require(msg.sender == owner);
        bool res = msg.sender.send(address(this).balance);
    }
}