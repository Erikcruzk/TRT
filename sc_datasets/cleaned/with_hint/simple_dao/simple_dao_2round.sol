pragma solidity ^0.4.2;

contract SimpleDAO {
mapping (address => uint) public credit;

function donate(address to) payable {
credit[to] += msg.value;
}

function withdraw(uint amount) {
require(credit[msg.sender] >= amount);
credit[msg.sender] -= amount;
bool res = msg.sender.call.value(amount)();
require(res);
}

function queryCredit(address to) returns (uint){
return credit[to];
}
}