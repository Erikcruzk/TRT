pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isLocked;

    function withdrawBalance() public {
        require(!isLocked[msg.sender], "Withdrawal in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        isLocked[msg.sender] = true; // lock the user's account

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");

        userBalances[msg.sender] = 0;
        isLocked[msg.sender] = false; // unlock the user's account
    }
} 

// The repaired contract prevents reentrancy attacks by locking the user's account during the withdrawal process. It also includes additional checks for insufficient balance and failed transfers.