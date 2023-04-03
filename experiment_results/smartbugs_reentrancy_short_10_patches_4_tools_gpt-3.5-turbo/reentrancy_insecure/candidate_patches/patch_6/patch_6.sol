/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: -
 * @fixed_at_lines: 10-15
 */

pragma solidity ^0.4.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is not already in a withdrawal process
        locked[msg.sender] = true; // lock the user
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false; // unlock the user
        require(msg.sender.call.value(amountToWithdraw)("")); // send the ether after modifying the state
    }
} 

// Changes Made:
// - Added a "locked" mapping to keep track of users already in a withdrawal process
// - Locked the user before executing the withdrawal
// - Unlocked the user after the withdrawal
// - Moved the transfer of ether after modifying the state and used the require statement to check for success