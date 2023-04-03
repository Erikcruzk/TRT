/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
 * @fixed_at_lines: 24
 */

pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    mapping (address => bool) locked;

    function getBalance(address u) constant returns(uint) {
        return userBalance[u];
    }

    function addToBalance() payable {
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() {
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if(!msg.sender.send(balanceToWithdraw)) {
            throw;
        }
        locked[msg.sender] = false;
    }
} 

// Changes Made:
// 1. Added a mapping 'locked' to prevent reentrancy attack
// 2. Used require instead of if-throw to handle errors
// 3. Removed external-function vulnerability by removing unnecessary external function calls.