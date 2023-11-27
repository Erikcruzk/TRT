pragma solidity ^0.4.23;

contract MultiOwnable {
address public root;
mapping (address => address) public owners;

constructor() public {
root = msg.sender;
owners[root] = root;
}

modifier onlyOwner() {
require(owners[msg.sender] != address(0));
_;
}

function newOwner(address _owner) external returns (bool) {
require(_owner != address(0));
require(owners[_owner] == address(0));
owners[_owner] = msg.sender;
return true;
}

function deleteOwner(address _owner) onlyOwner external returns (bool) {
require(_owner != root);
require(owners[_owner] == msg.sender || (owners[_owner] != address(0) && msg.sender == root));
require(getOwnerCount() > 1);
owners[_owner] = address(0);
return true;
}

function getOwnerCount() public view returns (uint256) {
uint256 count = 0;
for (uint256 i = 0; i < 256; i++) {
if (owners[address(i)] != address(0)) {
count++;
}
}
return count;
}
}

contract TestContract is MultiOwnable {
function withdrawAll() public onlyOwner payable {
msg.sender.transfer(address(this).balance);
}

function() public payable {
}
}