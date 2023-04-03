/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
 * @fixed_by: Your Name Here
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

    function withdrawBalance() {
        require(!locked[msg.sender]); // check if the sender is already withdrawing
        locked[msg.sender] = true; // lock the sender
        uint balanceToWithdraw = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        if (balanceToWithdraw > 0) {
            // send userBalance[msg.sender] ethers to msg.sender
            // if msg.sender is a contract, it will call its fallback function
            // <yes> <report> REENTRANCY
            if (!msg.sender.call.value(balanceToWithdraw)()) {
                throw;
            }
        }
        locked[msg.sender] = false; // unlock the sender
    }
}