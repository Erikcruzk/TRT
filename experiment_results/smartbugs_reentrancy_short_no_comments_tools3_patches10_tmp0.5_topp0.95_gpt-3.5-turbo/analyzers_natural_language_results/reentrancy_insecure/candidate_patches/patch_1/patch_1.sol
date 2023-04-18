pragma solidity ^0.4.24;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in the process of withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user balance before making the external call
        locked[msg.sender] = true; // Lock the user from making another withdrawal until the current transaction is complete
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false; // Unlock the user after the transaction is complete
    }
}