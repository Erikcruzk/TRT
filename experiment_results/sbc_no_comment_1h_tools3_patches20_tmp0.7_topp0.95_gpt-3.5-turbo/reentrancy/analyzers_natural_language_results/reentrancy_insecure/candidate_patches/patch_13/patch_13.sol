pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lockedAccounts;

    function withdrawBalance() public {
        require(!lockedAccounts[msg.sender]); // Check if the account is locked
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if the balance is greater than 0

        lockedAccounts[msg.sender] = true; // Lock the account to prevent reentrancy
        userBalances[msg.sender] = 0; // Update the balance before sending funds

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        lockedAccounts[msg.sender] = false; // Unlock the account
    }
}