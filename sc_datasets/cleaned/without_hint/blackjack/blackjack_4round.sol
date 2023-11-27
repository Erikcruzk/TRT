pragma solidity ^0.4.2;

library Deck {

function deal(address player, uint8 cardNumber) internal returns (uint8) {
uint b = block.number;
uint timestamp = block.timestamp;
return uint8(uint256(keccak256(abi.encodePacked(block.blockhash(b), player, cardNumber, timestamp))) % 52);
}

function valueOf(uint8 card, bool isBigAce) internal pure returns (uint8) {
uint8 value = card / 4;
if (value == 0 || value == 11 || value == 12) {
return 10;
}
if (value == 1 && isBigAce) {
return 11;
}
return value;
}

function isAce(uint8 card) internal pure returns (bool) {
return card / 4 == 1;
}

function isTen(uint8 card) internal pure returns (bool) {
return card / 4 == 10;
}
}

contract BlackJack {
using Deck for *;

uint public minBet = 50 finney;
uint public maxBet = 5 ether;

uint8 BLACKJACK = 21;

enum GameState { Ongoing, Player, Tie, House }

struct Game {
address player;
uint bet;
uint8[] houseCards;
uint8[] playerCards;
GameState state;
uint8 cardsDealt;
}

mapping (address => Game) public games;

modifier gameIsGoingOn() {
require(games[msg.sender].player != 0 && games[msg.sender].state == GameState.Ongoing);
_;
}

event Deal(bool isUser, uint8 _card);
event GameStatus(uint8 houseScore, uint8 houseScoreBig, uint8 playerScore, uint8 playerScoreBig);
event Log(uint8 value);

function BlackJack() public {}

function () public payable {}

function deal() public payable {
require(games[msg.sender].player == 0 || games[msg.sender].state != GameState.Ongoing);
require(msg.value >= minBet && msg.value <= maxBet);

uint8[] memory houseCards = new uint8[](1);
uint8[] memory playerCards = new uint8[](2);

playerCards[0] = Deck.deal(msg.sender, 0);
emit Deal(true, playerCards[0]);
houseCards[0] = Deck.deal(msg.sender, 1);
emit Deal(false, houseCards[0]);
playerCards[1] = Deck.deal(msg.sender, 2);
emit Deal(true, playerCards[1]);

games[msg.sender] = Game({
player: msg.sender,
bet: msg.value,
houseCards: houseCards,
playerCards: playerCards,
state: GameState.Ongoing,
cardsDealt: 3
});

checkGameResult(games[msg.sender], false);
}

function hit() public gameIsGoingOn {
uint8 nextCard = games[msg.sender].cardsDealt;
games[msg.sender].playerCards.push(Deck.deal(msg.sender, nextCard));
games[msg.sender].cardsDealt = nextCard + 1;
emit Deal(true, games[msg.sender].playerCards[games[msg.sender].playerCards.length - 1]);
checkGameResult(games[msg.sender], false);
}

function stand() public gameIsGoingOn {
var (houseScore, houseScoreBig) = calculateScore(games[msg.sender].houseCards);

while (houseScoreBig < 17) {
uint8 nextCard = games[msg.sender].cardsDealt;
uint8 newCard = Deck.deal(msg.sender, nextCard);
games[msg.sender].houseCards.push(newCard);
games[msg.sender].cardsDealt = nextCard + 1;
houseScoreBig += Deck.valueOf(newCard, true);
emit Deal(false, newCard);
}

checkGameResult(games[msg.sender], true);
}

function checkGameResult(Game storage game, bool finishGame) private {
var (houseScore, houseScoreBig) = calculateScore(game.houseCards);
var (playerScore, playerScoreBig) = calculateScore(game.playerCards);

emit GameStatus(houseScore, houseScoreBig, playerScore, playerScoreBig);

if (houseScoreBig == BLACKJACK || houseScore == BLACKJACK) {
if (playerScore == BLACKJACK || playerScoreBig == BLACKJACK) {
if (!msg.sender.send(game.bet)) revert();
game.state = GameState.Tie;
return;
} else {
game.state = GameState.House;
return;
}
} else {
if (playerScore == BLACKJACK || playerScoreBig == BLACKJACK) {
if (game.playerCards.length == 2 && (Deck.isTen(game.playerCards[0]) || Deck.isTen(game.playerCards[1]))) {
if (!msg.sender.send((game.bet * 5) / 2)) revert();
} else {
if (!msg.sender.send(game.bet * 2)) revert();
}
game.state = GameState.Player;
return;
} else {
if (playerScore > BLACKJACK) {
emit Log(1);
game.state = GameState.House;
return;
}

if (!finishGame) {
return;
}

uint8 playerShortage = 0;
uint8 houseShortage = 0;

if (playerScoreBig > BLACKJACK) {
if (playerScore > BLACKJACK) {
game.state = GameState.House;
return;
} else {
playerShortage = BLACKJACK - playerScore;
}
} else {
playerShortage = BLACKJACK - playerScoreBig;
}

if (houseScoreBig > BLACKJACK) {
if (houseScore > BLACKJACK) {
if (!msg.sender.send(game.bet * 2)) revert();
game.state = GameState.Player;
return;
} else {
houseShortage = BLACKJACK - houseScore;
}
} else {
houseShortage = BLACKJACK - houseScoreBig;
}

if (houseShortage == playerShortage) {
if (!msg.sender.send(game.bet)) revert();
game.state = GameState.Tie;
} else if (houseShortage > playerShortage) {
if (!msg.sender.send(game.bet * 2)) revert();
game.state = GameState.Player;
} else {
game.state = GameState.House;
}
}
}
}

function calculateScore(uint8[] cards) private pure returns (uint8, uint8) {
uint8 score = 0;
uint8 scoreBig = 0;
bool bigAceUsed = false;
for (uint i = 0; i < cards.length; ++i) {
uint8 card = cards[i];
if (Deck.isAce(card) && !bigAceUsed) {
scoreBig += Deck.valueOf(card, true);
bigAceUsed = true;
} else {
scoreBig += Deck.valueOf(card, false);
}
score += Deck.valueOf(card, false);
}
return (score, scoreBig);
}

function getPlayerCard(uint8 id) public gameIsGoingOn constant returns(uint8) {
require(id >= 0 && id < games[msg.sender].playerCards.length);
return games[msg.sender].playerCards[id];
}

function getHouseCard(uint8 id) public gameIsGoingOn constant returns(uint8) {
require(id >= 0 && id < games[msg.sender].houseCards.length);
return games[msg.sender].houseCards[id];
}

function getPlayerCardsNumber() public gameIsGoingOn constant returns(uint) {
return games[msg.sender].playerCards.length;
}

function getHouseCardsNumber() public gameIsGoingOn constant returns(uint) {
return games[msg.sender].houseCards.length;
}

function getGameState() public constant returns (uint8) {
require(games[msg.sender].player != 0);

Game storage game = games[msg.sender];

if (game.state == GameState.Player) {
return 1;
}
if (game.state == GameState.House) {
return 2;
}
if (game.state == GameState.Tie) {
return 3;
}

return 0;
}
}