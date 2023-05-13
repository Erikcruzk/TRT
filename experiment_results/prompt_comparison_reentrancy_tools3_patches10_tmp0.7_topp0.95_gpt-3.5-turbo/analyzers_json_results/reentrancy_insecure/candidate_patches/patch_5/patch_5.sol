pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in a withdrawal process
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true; // Set the user as locked during the withdrawal process

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        
        locked[msg.sender] = false; // Release the lock after the withdrawal process is completed
    }
} 

// The repaired contract includes a lock mechanism to prevent reentrancy attacks. The lock is set for each user during the withdrawal process and released after the process is completed. Additionally, the state variable userBalances is updated before the external call to prevent reentrancy attacks.