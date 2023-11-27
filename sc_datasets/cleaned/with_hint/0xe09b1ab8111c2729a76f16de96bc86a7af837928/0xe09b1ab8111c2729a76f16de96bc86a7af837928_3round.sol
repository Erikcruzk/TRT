pragma solidity ^0.8.0;

contract FiftyFlip {
uint constant DONATING_X = 20;
uint constant JACKPOT_FEE = 10;
uint constant JACKPOT_MODULO = 1000;
uint constant DEV_FEE = 20;
uint constant WIN_X = 1900;
uint constant MIN_BET = 0.01 ether;
uint constant MAX_BET = 1 ether;
uint constant BET_EXPIRATION_BLOCKS = 250;
address public owner;
address public autoPlayBot;
address public secretSigner;
address payable private whale;
uint256 public jackpotSize;
uint256 public devFeeSize;
uint256 public lockedInBets;
uint256 public totalAmountToWhale;
struct Bet {
uint amount;
uint256 blockNumber;
bool betMask;
address player;
}
mapping (uint => Bet) bets;
mapping (address => uint) donateAmount;
event Wager(uint ticketID, uint betAmount, uint256 betBlockNumber, bool betMask, address betPlayer);
event Win(address winner, uint amount, uint ticketID, bool maskRes, uint jackpotRes);
event Lose(address loser, uint amount, uint ticketID, bool maskRes, uint jackpotRes);
event Refund(uint ticketID, uint256 amount, address requester);
event Donate(uint256 amount, address donator);
event FailedPayment(address paidUser, uint amount);
event Payment(address noPaidUser, uint amount);
event JackpotPayment(address player, uint ticketID, uint jackpotWin);
constructor (address payable whaleAddress, address autoPlayBotAddress, address secretSignerAddress) {
owner = msg.sender;
autoPlayBot = autoPlayBotAddress;
whale = whaleAddress;
secretSigner = secretSignerAddress;
jackpotSize = 0;
devFeeSize = 0;
lockedInBets = 0;
totalAmountToWhale = 0;
}
modifier onlyOwner() {
require (msg.sender == owner, "You are not the owner of this contract!");
_;
}
modifier onlyBot() {
require (msg.sender == autoPlayBot, "You are not the bot of this contract!");
_;
}
modifier checkContractHealth() {
require (address(this).balance >= lockedInBets + jackpotSize + devFeeSize, "This contract doesn't have enough balance, it is stopped till someone donate to this game!");
_;
}
function setBotAddress(address autoPlayBotAddress) external onlyOwner() {
autoPlayBot = autoPlayBotAddress;
}
function setSecretSigner(address _secretSigner) external onlyOwner() {
secretSigner = _secretSigner;
}
function wager(bool bMask, uint ticketID, uint ticketLastBlock, uint8 v, bytes32 r, bytes32 s) external payable checkContractHealth() {
Bet storage bet = bets[ticketID];
uint amount = msg.value;
address player = msg.sender;
require (bet.player == address(0), "Ticket is not new one!");
require (amount >= MIN_BET, "Your bet is lower than minimum bet amount");
require (amount <= MAX_BET, "Your bet is higher than maximum bet amount");
require (getCollateralBalance() >= 2 * amount, "If we accept this, this contract will be in danger!");
require (block.number <= ticketLastBlock, "Ticket has expired.");
bytes32 signatureHash = keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n37', uint40(ticketLastBlock), ticketID));
require (secretSigner == ecrecover(signatureHash, v, r, s), "web3 vrs signature is not valid.");
jackpotSize += amount * JACKPOT_FEE / 1000;
devFeeSize += amount * DEV_FEE / 1000;
lockedInBets += amount * WIN_X / 1000;
uint donate_amount = amount * DONATING_X / 1000;
whale.call{value: donate_amount}(bytes4(keccak256("donate()")));
totalAmountToWhale += donate_amount;
bet.amount = amount;
bet.blockNumber = block.number;
bet.betMask = bMask;
bet.player = player;
emit Wager(ticketID, bet.amount, bet.blockNumber, bet.betMask, bet.player);
}
function play(uint ticketReveal) external checkContractHealth() {
uint ticketID = uint(keccak256(abi.encodePacked(ticketReveal)));
Bet storage bet = bets[ticketID];
require (bet.player != address(0), "TicketID is not correct!");
require (bet.amount != 0, "Ticket is already used one!");
uint256 blockNumber = bet.blockNumber;
if(blockNumber < block.number && blockNumber >= block.number - BET_EXPIRATION_BLOCKS) {
uint256 random = uint256(keccak256(abi.encodePacked(blockhash(blockNumber),  ticketReveal, block.timestamp)));
bool maskRes = (random % 2) !=0;
uint jackpotRes = random % JACKPOT_MODULO;
uint tossWinAmount = bet.amount * WIN_X / 1000;
uint tossWin = 0;
uint jackpotWin = 0;
if(bet.betMask == maskRes) {
tossWin = tossWinAmount;
}
if(jackpotRes == 0) {
jackpotWin = jackpotSize;
jackpotSize = 0;
}
if (jackpotWin > 0) {
emit JackpotPayment(bet.player, ticketID, jackpotWin);
}
if(tossWin + jackpotWin > 0) {
payout(bet.player, tossWin + jackpotWin, ticketID, maskRes, jackpotRes);
}