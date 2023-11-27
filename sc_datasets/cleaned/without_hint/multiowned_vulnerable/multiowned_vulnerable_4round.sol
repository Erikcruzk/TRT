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

function newOwner(address _owner) external onlyOwner returns (bool) {
require(_owner != address(0));
owners[_owner] = msg.sender;
return true;
}

function deleteOwner(address _owner) external onlyOwner returns (bool) {
require(owners[_owner] == msg.sender || (owners[_owner] != address(0) && msg.sender == root));
owners[_owner] = address(0);
return true;
}
}

contract TestContract is MultiOwnable {
function withdrawAll() external onlyOwner {
msg.sender.transfer(address(this).balance);
}

function() external payable {
}
}