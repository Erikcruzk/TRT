pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Reentrancy guard
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if user has balance

        locked[msg.sender] = true; // Lock user's account
        userBalances[msg.sender] = 0; // Update user's balance before external call

        require(msg.sender.call.value(amountToWithdraw)()); // External call to user's address

        locked[msg.sender] = false; // Unlock user's account
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value; // Add deposited amount to user's balance
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// The repaired contract adds a reentrancy guard to prevent a user from calling the withdrawBalance function multiple times before the previous execution is completed. The user's balance is updated before the external call to prevent reentrancy attacks. Additionally, a deposit function is added to allow users to add funds to their balance. The getBalance function is added to enable users to check their current balance.