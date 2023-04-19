pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
} 

// Changes made:
// 1. Added a mapping to keep track of locked addresses to prevent reentrancy.
// 2. Moved the state variable update before the external call to prevent reentrancy. 
// 3. Replaced the external call with transfer() function to prevent reentrancy.