pragma solidity ^0.4.24;

contract SimpleWallet {
address public owner = msg.sender;
uint public depositsCount;

modifier onlyOwner {
require(msg.sender == owner);
_;
}

function() public payable {
depositsCount++;
}

function withdrawAll() public onlyOwner {
owner.transfer(address(this).balance);
}

function withdraw(uint _value) public onlyOwner {
owner.transfer(_value);
}

function sendMoney(address _target, uint _value, bytes _data) public onlyOwner {
require(_target != address(0));
require(_target != address(this));
require(_value <= address(this).balance);

_target.call.value(_value)(_data);
}
}