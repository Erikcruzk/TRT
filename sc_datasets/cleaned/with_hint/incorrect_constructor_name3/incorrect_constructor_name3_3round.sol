pragma solidity ^0.4.24;

contract MyContract {
address private owner;

modifier onlyOwner {
require(msg.sender == owner);
_;
}

constructor() public {
owner = msg.sender;
}

function() public payable {

}

function withdraw() public onlyOwner {
require(address(this).balance > 0);
owner.transfer(address(this).balance);
}
}