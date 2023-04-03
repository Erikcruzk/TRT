/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @vulnerable_at_lines: 17
 */

pragma solidity ^0.4.0;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is not already withdrawing
        locked[msg.sender] = true; // Lock the user
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)("")); // Withdraw the balance
        locked[msg.sender] = false; // Unlock the user
    }
}