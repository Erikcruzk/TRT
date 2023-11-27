pragma solidity ^0.4.24;

contract LuckyDoubler {
address private owner;
uint private balance = 0;
uint private fee = 5;
uint private multiplier = 125;
Entry[] private entries;
uint[] private unpaidEntries;

struct User {
uint deposits;
uint payoutsReceived;
}

struct Entry {
address entryAddress;
uint deposit;
uint payout;
bool paid;
}

mapping (address => User) private users;

constructor() public {
owner = msg.sender;
}

modifier onlyOwner() {
require(msg.sender == owner);
_;
}

function rand(uint max) private view returns (uint256 result) {
uint256 factor = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender))) % max;
return factor;
}

function join() private {
uint dValue = 1 ether;

if (msg.value > 1 ether) {
msg.sender.transfer(msg.value - 1 ether);
dValue = 1 ether;
}

if (users[msg.sender].deposits == 0) {
users[msg.sender] = User(0, 0);
}

entries.push(Entry(msg.sender, dValue, (dValue * multiplier) / 100, false));
users[msg.sender].deposits++;
unpaidEntries.push(entries.length - 1);

balance += (dValue * (100 - fee)) / 100;

uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;
Entry storage theEntry = entries[unpaidEntries[index]];

if (balance > theEntry.payout) {
uint payout = theEntry.payout;

theEntry.entryAddress.transfer(payout);
theEntry.paid = true;
users[theEntry.entryAddress].payoutsReceived++;

balance -= payout;

if (index < unpaidEntries.length - 1) {
unpaidEntries[index] = unpaidEntries[unpaidEntries.length - 1];
}

unpaidEntries.length--;
}

uint fees = address(this).balance - balance;
if (fees > 0) {
owner.transfer(fees);
}
}

function() public payable {
join();
}

function changeOwner(address newOwner) public onlyOwner {
owner = newOwner;
}

function changeMultiplier(uint newMultiplier) public onlyOwner {
require(newMultiplier >= 110 && newMultiplier <= 150);
multiplier = newMultiplier;
}

function changeFee(uint newFee) public onlyOwner {
require(newFee <= 5);
fee = newFee;
}

function getMultiplierFactor() public view returns (uint, string) {
return (multiplier, "The current multiplier applied to all deposits. Min 110%, max 150%.");
}

function getCurrentFee() public view returns (uint, string) {
return (fee, "The fee percentage applied to all deposits. It can change to speed payouts (max 5%).");
}

function getTotalEntries() public view returns (uint, string) {
return (entries.length, "The number of deposits.");
}

function getUserStats(address user) public view returns (uint, uint, string) {
if (users[user].deposits > 0) {
return (users[user].deposits, users[user].payoutsReceived, "Users stats: total deposits, payouts received.");
} else {
return (0, 0, "");
}
}

function getEntryDetails(uint index) public view returns (address, uint, bool, string) {
if (index < entries.length) {
Entry storage theEntry = entries[index];
return (theEntry.entryAddress, theEntry.payout / 1 finney, theEntry.paid, "Entry info: user address, expected payout in Finneys, payout status.");
} else {
return (address(0), 0, false, "");
}
}
}