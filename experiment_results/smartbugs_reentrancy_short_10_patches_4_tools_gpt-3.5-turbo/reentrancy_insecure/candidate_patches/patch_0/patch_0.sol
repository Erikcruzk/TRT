/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 */

pragma solidity ^0.4.24;

contract Reentrancy_fixed {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
        locked[msg.sender] = false;
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}

// The repaired contract adds a simple locking mechanism to prevent reentrancy attacks. 
// The function withdrawBalance() now checks if the sender is already executing the function before continuing. 
// If the sender is not locked, the function will lock the sender, transfer the funds, and unlock the sender. 
// If the sender is already locked, the function will revert.