/*
 * @source: https://github.com/ConsenSys/evm-analyzer-benchmark-suite
 * @author: 
 * @vulnerable_at_lines: 18
 */

pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            balance -= oCredit;
            bool callResult = msg.sender.call.value(oCredit)();
            require (callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made:
// 1. Moved the credit[msg.sender] = 0; line before balance -= oCredit; to prevent reentrancy attack.
// 2. Removed the unnecessary author name from the comment.