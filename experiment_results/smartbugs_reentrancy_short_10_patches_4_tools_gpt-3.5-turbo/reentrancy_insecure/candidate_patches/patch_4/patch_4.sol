/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: 
 * @vulnerable_at_lines: 17
 */

pragma solidity ^0.4.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in a withdrawal process
        locked[msg.sender] = true; // Lock the user's account
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false; // Unlock the user's account
        require(msg.sender.call.value(amountToWithdraw)("")); // Send the funds last to prevent reentrancy
    }
}