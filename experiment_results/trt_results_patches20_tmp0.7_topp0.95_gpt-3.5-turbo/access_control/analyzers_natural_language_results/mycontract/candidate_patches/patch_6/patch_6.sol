pragma solidity ^0.4.24;

contract MyContract {
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint amount) public {
        require(msg.sender == owner);
        require(receiver != address(0));
        receiver.transfer(amount);
    }
}