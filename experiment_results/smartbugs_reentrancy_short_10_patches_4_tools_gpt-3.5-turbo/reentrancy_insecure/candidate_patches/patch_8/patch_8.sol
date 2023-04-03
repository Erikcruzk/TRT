/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @fixed_at_lines: 17
 */

pragma solidity ^0.4.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // Check if the user is already in a withdraw process
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true; // Lock the user's balance
        userBalances[msg.sender] = 0; // Set the user's balance to zero before sending
        require(msg.sender.call.value(amountToWithdraw)(""));
        locked[msg.sender] = false; // Unlock the user's balance after sending
    }
}