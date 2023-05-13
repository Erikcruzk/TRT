pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in the middle of a transaction
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if the user has any balance to withdraw
        locked[msg.sender] = true; // Lock the user to prevent reentrancy
        
        msg.sender.transfer(amountToWithdraw); // Use transfer instead of call to prevent reentrancy
        
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false; // Unlock the user
    }
}