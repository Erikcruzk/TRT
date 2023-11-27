pragma solidity ^0.4.18;

contract Ownable {
address public newOwner;
address public owner;

function Ownable() public {
owner = msg.sender;
}

function changeOwner(address addr) public onlyOwner {
newOwner = addr;
}

function confirmOwner() public {
require(msg.sender == newOwner);
owner = newOwner;
newOwner = address(0);
}

modifier onlyOwner() {
require(msg.sender == owner);
_;
}
}

contract Token is Ownable {
function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
}
}

contract TokenBank is Token {
uint public minDeposit;
mapping (address => uint) public holders;

function TokenBank() public {
owner = msg.sender;
minDeposit = 1 ether;
}

function() public payable {
deposit();
}

function deposit() public payable {
require(msg.value >= minDeposit);
holders[msg.sender] += msg.value;
}

function withdrawTokenToHolder(address to, address token, uint amount) public onlyOwner {
require(holders[to] > 0);
holders[to] = 0;
withdrawToken(token, amount, to);
}

function withdrawToHolder(address addr, uint weiAmount) public onlyOwner {
require(holders[msg.sender] > 0);
require(holders[addr] >= weiAmount);
addr.transfer(weiAmount);
holders[addr] -= weiAmount;
}

function balance() public view returns (uint) {
return address(this).balance;
}
}