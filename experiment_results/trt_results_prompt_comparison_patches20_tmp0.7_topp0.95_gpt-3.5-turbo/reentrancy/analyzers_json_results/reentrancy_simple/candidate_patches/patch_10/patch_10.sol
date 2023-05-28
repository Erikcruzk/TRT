pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) public constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() public payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check that the sender is not already in the withdraw process
        locked[msg.sender] = true; // lock the sender
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // set the balance to zero before sending to prevent re-entrancy
        msg.sender.transfer(balance); // send the balance to the sender
        locked[msg.sender] = false; // unlock the sender
    }
}