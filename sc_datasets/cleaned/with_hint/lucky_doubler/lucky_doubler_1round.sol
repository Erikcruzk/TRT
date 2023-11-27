pragma solidity ^0.4.24;

contract LuckyDoubler {
address private owner;
uint private balance = 0;
uint private fee = 5;
uint private multiplier = 125;

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

User[] private users;
Entry[] private entries;
uint[] private unpaidEntries;

constructor() public {
owner = msg.sender;
}

modifier onlyOwner() {
require(msg.sender == owner);
_;
}

function rand(uint max) private view returns (uint256) {
uint256 factor = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender))) % max;
return factor;
}

function join() private {
require(msg.value >= 1 ether);

uint dValue = 1 ether;

if (msg.value > 1 ether) {
msg.sender.transfer(msg.value - 1 ether);
dValue = 1 ether;
}

if (users.length == 0) {
users.push(User(0, 0));
}

if (users[msg.sender].deposits == 0) {
users.push(User(0, 0));
}

entries.push(Entry(msg.sender, dValue, (dValue * multiplier) / 100, false));
users[users.length - 1].deposits++;
unpaidEntries.push(entries.length - 1);

balance += (dValue * (100 - fee)) / 100;

uint index = unpaidEntries.length > 1 ? rand(unpaidEntries.length) : 0;
Entry storage theEntry = entries[unpaidEntries[index]];

if (balance > theEntry.payout) {
uint payout = theEntry.payout;

theEntry.entryAddress.transfer(payout);
theEntry.paid = true;
users[getIndex(theEntry.entryAddress)].payoutsReceived++;

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

function getIndex(address userAddress) private view returns (uint) {
for (uint i = 0; i < users.length; i++) {
if (users[i].deposits > 0 && users[i].id == userAddress) {
return i;
}
}
return 0;
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

function getUserStats(address userAddress) public view returns (uint, uint, string) {
uint index = getIndex(userAddress);
return (users[index].deposits, users[index].payoutsReceived, "Users stats: total deposits, payouts received.");
}

function getEntryDetails(uint index) public view returns (address, uint, bool, string) {
return (entries[index].entryAddress, entries[index].payout / 1 finney, entries[index].paid, "Entry info: user address, expected payout in Finneys, payout status.");
}

function() public payable {
join();
}
}