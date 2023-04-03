/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author: -
 * @fixed_at_lines: 24
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
         // send userBalance[msg.sender] ethers to msg.sender
         // if mgs.sender is a contract, it will call its fallback function
         // <yes> <report> REENTRANCY
         require(!locked[msg.sender]);
         locked[msg.sender] = true;
         if( ! (msg.sender.call.value(userBalance[msg.sender])() ) ){
             locked[msg.sender] = false;
             throw;
         }
         userBalance[msg.sender] = 0;
         locked[msg.sender] = false;
     }
 } 

// Changes Made:
// 1. Added a mapping to keep track of locked addresses
// 2. Added a require statement to check if the address is locked or not
// 3. Added locked[msg.sender] = true; to lock the address before calling external function
// 4. Added locked[msg.sender] = false; to unlock the address after the external function call is complete.