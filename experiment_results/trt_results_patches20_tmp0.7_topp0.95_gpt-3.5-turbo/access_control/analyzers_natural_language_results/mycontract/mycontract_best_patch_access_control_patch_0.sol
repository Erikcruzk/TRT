pragma solidity ^0.4.24;

contract MyContract {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public onlyOwner {
        require(address(this).balance >= amount);
        receiver.transfer(amount);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}