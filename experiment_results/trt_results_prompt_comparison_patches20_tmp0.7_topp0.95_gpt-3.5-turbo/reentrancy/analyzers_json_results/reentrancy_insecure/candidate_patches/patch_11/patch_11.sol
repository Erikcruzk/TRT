pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in a withdrawal process
        locked[msg.sender] = true; // Set the user as locked to prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Set the user balance to 0 before making external call
        require(msg.sender.call.value(amountToWithdraw)()); // Make the external call last
        locked[msg.sender] = false; // Unlock the user
    }
    
    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}