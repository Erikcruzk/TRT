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
        require(!locked[msg.sender]); // Check if sender is already in a withdrawal process
        locked[msg.sender] = true; // Lock the sender to prevent reentrancy
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0; // Set the balance to 0 before sending to prevent reentrancy
        // send userBalance[msg.sender] ethers to msg.sender
        // if mgs.sender is a contract, it will call its fallback function
        // <yes> <report> REENTRANCY
        if( ! (msg.sender.call.value(balance)() ) ){
            userBalance[msg.sender] = balance; // Revert balance if the transfer failed
        }
        locked[msg.sender] = false; // Unlock the sender
    }
}