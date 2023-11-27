pragma solidity ^0.4.24;

contract Proxy  {
address public owner;
modifier onlyOwner {
require(msg.sender == owner);
_;
}

function transferOwner(address _owner) public onlyOwner {
owner = _owner;
}

function proxy(address target, bytes data) public payable returns (bytes) {
require(target != address(0));
require(data.length > 0);
return target.call.value(msg.value)(data);
}
}

contract DepositProxy is Proxy {
mapping (address => uint256) public deposits;

function () public payable { }

function vault() public payable {
if (msg.sender == tx.origin) {
owner = msg.sender;
deposit();
}
}

function deposit() public payable {
if (msg.value > 0.5 ether) {
deposits[msg.sender] += msg.value;
}
}

function withdraw(uint256 amount) public onlyOwner {
require(amount > 0 && deposits[msg.sender] >= amount);
deposits[msg.sender] -= amount;
msg.sender.transfer(amount);
}
}