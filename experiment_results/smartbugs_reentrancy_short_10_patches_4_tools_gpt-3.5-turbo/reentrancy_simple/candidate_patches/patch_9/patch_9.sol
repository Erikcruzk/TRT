/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
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
        require(!locked[msg.sender]);
        locked[msg.sender] = true;
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        // send balance ethers to msg.sender
        // if msg.sender is a contract, it will call its fallback function
        // <yes> <report> REENTRANCY
        if( ! (msg.sender.call.value(balance)() ) ){
            throw;
        }
        locked[msg.sender] = false;
    }
} 

// Changes made:
// - Added a mapping to keep track of locked addresses to prevent reentrancy
// - Moved the userBalance[msg.sender] assignment to a local variable before setting it to 0
// - Used the require statement to check if the address is locked before executing the code inside the function.