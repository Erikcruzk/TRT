pragma solidity ^0.4.24;

contract MyContract {
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public onlyOwner {
        receiver.transfer(amount);
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}