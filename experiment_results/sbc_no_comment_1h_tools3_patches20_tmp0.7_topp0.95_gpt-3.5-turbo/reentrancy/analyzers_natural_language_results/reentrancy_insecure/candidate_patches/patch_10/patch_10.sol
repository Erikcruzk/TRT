pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a mapping 'locked' to keep track of whether a user is currently locked in a transaction or not.
// 2. Added a check to ensure that the user is not already locked in a transaction before proceeding with the withdrawal.
// 3. Moved the statement to set userBalances[msg.sender] to 0 before the external call to prevent reentrancy attacks.
// 4. Added a statement to set locked[msg.sender] to true before the external call to prevent reentrancy attacks.
// 5. Added a statement to set locked[msg.sender] to false after the external call to prevent reentrancy attacks.