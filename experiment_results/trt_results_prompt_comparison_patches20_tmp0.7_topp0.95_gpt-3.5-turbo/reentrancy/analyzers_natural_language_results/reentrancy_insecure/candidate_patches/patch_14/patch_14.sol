pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in a transaction
        locked[msg.sender] = true; // Lock the user
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Set the user's balance to zero before making the external call
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false; // Unlock the user after the transaction is complete
    }
}