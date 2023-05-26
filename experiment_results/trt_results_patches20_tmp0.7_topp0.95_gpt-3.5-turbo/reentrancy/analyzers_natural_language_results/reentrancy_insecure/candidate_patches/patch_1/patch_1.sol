pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private reentrancyLock;

    function withdrawBalance() public {
        require(!reentrancyLock[msg.sender]); // Prevent reentrancy
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Ensure user has balance to withdraw
        reentrancyLock[msg.sender] = true; // Lock the function before external call

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success); // Ensure external call to user address is successful
        userBalances[msg.sender] = 0;

        reentrancyLock[msg.sender] = false; // Unlock the function after external call
    }
}