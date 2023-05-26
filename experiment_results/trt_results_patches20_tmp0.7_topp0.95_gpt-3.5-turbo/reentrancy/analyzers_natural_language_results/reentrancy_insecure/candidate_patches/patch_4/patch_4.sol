pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isLocked;

    function withdrawBalance() public {
        require(!isLocked[msg.sender]); // check if the user is already in a transaction
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // check if the user has any balance

        isLocked[msg.sender] = true; // lock the user to prevent reentrancy

        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success); // check if the transfer was successful

        isLocked[msg.sender] = false; // unlock the user
    }
}