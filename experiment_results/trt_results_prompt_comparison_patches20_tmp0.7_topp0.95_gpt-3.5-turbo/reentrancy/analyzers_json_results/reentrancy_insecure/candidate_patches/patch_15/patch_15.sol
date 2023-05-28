pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a boolean mapping "locked" to keep track of whether a user is already in a withdraw function or not.
// 2. Added a require statement to check if the user is already in a withdraw function before executing it.
// 3. Added a require statement to check if the user has any balance to withdraw.
// 4. Moved the setting of the balance to 0 after the require statement to prevent reentrancy attack.
// 5. Added a require statement to check if the external call was successful.
// 6. Added a statement to unlock the user after the external call is completed.