pragma solidity ^0.4.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update balance before external call
        require(msg.sender.call.value(amountToWithdraw)()); // Use require instead of (bool success, ) to prevent reentrancy
    }
}