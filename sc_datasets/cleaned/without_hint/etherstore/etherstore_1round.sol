pragma solidity ^0.4.0;

contract EtherStore {

uint256 public withdrawalLimit = 1 ether;
mapping(address => uint256) public lastWithdrawTime;
mapping(address => uint256) public balances;

function depositFunds() public payable {
balances[msg.sender] += msg.value;
}

function withdrawFunds (uint256 _weiToWithdraw) public {
require(balances[msg.sender] >= _weiToWithdraw);
require(_weiToWithdraw <= withdrawalLimit);
require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
require(msg.sender.call.value(_weiToWithdraw)());
balances[msg.sender] -= _weiToWithdraw;
lastWithdrawTime[msg.sender] = now;
}

function increaseWithdrawalLimit(uint256 _newLimit) public {
require(_newLimit > withdrawalLimit);
require(msg.sender.balance >= _newLimit);
withdrawalLimit = _newLimit;
}

function emergencyWithdrawal() public {
require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
uint256 balanceToWithdraw = balances[msg.sender];
balances[msg.sender] = 0;
msg.sender.transfer(balanceToWithdraw);
}
}