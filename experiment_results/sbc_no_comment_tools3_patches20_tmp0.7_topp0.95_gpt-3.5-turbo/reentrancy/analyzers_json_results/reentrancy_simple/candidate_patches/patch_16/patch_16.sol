pragma solidity ^0.4.15;

contract Reentrance {
    mapping(address => uint) userBalance;
    mapping(address => bool) locked;

    function getBalance(address u) constant returns (uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked[msg.sender]); // Prevents reentrancy
        locked[msg.sender] = true; // Locks the function to prevent reentrancy
        uint amount = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.send(amount)) {
            userBalance[msg.sender] = amount; // Reverts changes if send fails
            locked[msg.sender] = false; // Unlocks the function
            revert();
        }
        locked[msg.sender] = false; // Unlocks the function
    }
}