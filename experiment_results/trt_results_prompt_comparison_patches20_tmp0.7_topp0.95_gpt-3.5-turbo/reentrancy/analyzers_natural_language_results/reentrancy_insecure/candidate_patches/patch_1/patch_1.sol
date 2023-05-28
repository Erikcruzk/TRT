pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lock;

    function withdrawBalance() public {
        require(!lock[msg.sender]); // Check if the sender is already in the process of withdrawing
        lock[msg.sender] = true; // Set the sender to be in the process of withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Set the balance to be withdrawn to zero before the external call
        require(msg.sender.call.value(amountToWithdraw)()); // Perform the external call
        lock[msg.sender] = false; // Set the sender to be done withdrawing
    }
}