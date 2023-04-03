/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author: -
 * @fixed_by: [Your Name]
 * @vulnerable_at_lines: 24
 */

pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    mapping (address => bool) locked;

    function getBalance(address u) constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() payable{
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance(){
        require(!locked[msg.sender]); // prevent reentrancy
        locked[msg.sender] = true; // lock the user's account
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if( ! (msg.sender.call.value(balance)() ) ){
            userBalance[msg.sender] = balance; // revert the changes
            locked[msg.sender] = false; // unlock the user's account
            revert();
        }
        locked[msg.sender] = false; // unlock the user's account
    }
} 

// Changes Made:
// - Added a mapping to keep track of locked accounts to prevent reentrancy attack
// - Moved the balance check and reset before the external call to prevent race conditions
// - Added a check to ensure the account is not locked before allowing a withdrawal
// - Added a revert statement in case the external call fails to prevent the transfer of funds and revert changes made to the user's balance and locked status.