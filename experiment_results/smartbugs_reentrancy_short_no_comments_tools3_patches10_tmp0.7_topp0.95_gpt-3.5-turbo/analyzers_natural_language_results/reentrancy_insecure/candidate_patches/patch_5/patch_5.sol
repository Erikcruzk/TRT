pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already withdrawing funds
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true; // Lock the user account to prevent reentrancy
        require(amountToWithdraw > 0); // Check if user has funds to withdraw
        userBalances[msg.sender] = 0; // Set user balance to zero before making external call
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // Make external call
        require(success); // Check if external call was successful
        locked[msg.sender] = false; // Unlock user account after external call is complete
    }
}