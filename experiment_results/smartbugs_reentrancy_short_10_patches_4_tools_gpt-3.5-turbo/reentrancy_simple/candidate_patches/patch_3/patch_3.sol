/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
 * @fixed_by: Team XYZ
 * @vulnerable_at_lines: 24
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
        uint amountToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (!msg.sender.call.value(amountToWithdraw)()) {
            revert();
        }
        locked[msg.sender] = false;
    }
} 

// Changes made:
// - Added a new mapping called 'locked' to keep track of whether a user is already withdrawing funds or not.
// - Added a 'require' statement to check if the user is not already withdrawing funds.
// - Added a new variable 'amountToWithdraw' to store the amount of ether to withdraw.
// - Moved the line 'userBalance[msg.sender] = 0;' before the 'if' statement to prevent reentrancy attacks.
// - Changed 'throw' to 'revert' for better error handling.