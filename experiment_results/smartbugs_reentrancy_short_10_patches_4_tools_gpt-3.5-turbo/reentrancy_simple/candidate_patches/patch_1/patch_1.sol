/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
 * @fixed_by: Your Name
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
         require(!locked[msg.sender]); // check if the user is already withdrawing funds
         locked[msg.sender] = true; // lock the user's account

         uint balanceToWithdraw = userBalance[msg.sender];
         userBalance[msg.sender] = 0;

         // send balanceToWithdraw ethers to msg.sender
         // if msg.sender is a contract, it will call its fallback function
         // <yes> <report> REENTRANCY
         if( ! (msg.sender.call.value(balanceToWithdraw)() ) ){
             revert(); // revert the transaction if the call fails
         }

         locked[msg.sender] = false; // unlock the user's account
     }
 } 

// Changes Made
// Added a mapping to keep track of locked accounts during withdrawal process
// Added a require statement to check if the user is already withdrawing funds
// Moved the balance calculation before sending the funds to prevent reentrancy vulnerability
// Added a revert statement to revert the transaction if the call to send funds fails.