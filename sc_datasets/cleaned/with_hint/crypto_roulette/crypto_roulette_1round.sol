pragma solidity ^0.4.24;

contract CryptoRoulette {

uint256 private secretNumber;
uint256 public lastPlayed;
uint256 public betPrice = 0.1 ether;
address public ownerAddr;

struct Game {
address player;
uint256 number;
}
Game[] public gamesPlayed;

constructor() public {
ownerAddr = msg.sender;
shuffle();
}

function shuffle() internal {
secretNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 10 + 1;
}

function play(uint256 number) payable public {
require(msg.value >= betPrice && number <= 10 && number > 0);

Game memory game = Game({
player: msg.sender,
number: number
});
gamesPlayed.push(game);

if (number == secretNumber) {
msg.sender.transfer(address(this).balance);
}

shuffle();
lastPlayed = now;
}

function kill() public {
require(msg.sender == ownerAddr && now > lastPlayed + 1 days);
selfdestruct(ownerAddr);
}

function() public payable { }
}