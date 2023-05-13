pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private reentrancyLock;

    function withdrawBalance() public {
        require(!reentrancyLock[msg.sender]); // Check if the user has an active reentrancy lock
        reentrancyLock[msg.sender] = true; // Set the user's reentrancy lock
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update state before sending funds

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        reentrancyLock[msg.sender] = false; // Release the user's reentrancy lock
    }
} 

// The repaired contract includes a reentrancy lock to prevent a malicious user from executing the function multiple times within the same transaction. Additionally, the state variable userBalances is updated before sending funds to prevent any reentrancy-related issues.