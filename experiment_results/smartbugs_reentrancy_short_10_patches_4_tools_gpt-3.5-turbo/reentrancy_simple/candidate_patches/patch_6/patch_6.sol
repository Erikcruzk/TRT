/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
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
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        // send userBalance[msg.sender] ethers to msg.sender
        // if mgs.sender is a contract, it will call its fallback function
        // <yes> <report> REENTRANCY
        if( !msg.sender.send(balanceToWithdraw) ){
            locked[msg.sender] = false;
            userBalance[msg.sender] = balanceToWithdraw;
            revert();
        }
        locked[msg.sender] = false;
    }
} 

// Changes made:
// - Added a mapping to keep track of locked accounts to prevent reentrancy attack
// - Moved the balance calculation outside of the external call to prevent reentrancy attack
// - Replaced the call function with send function to prevent reentrancy attack
// - Added a revert function to revert the changes made if the external call fails.