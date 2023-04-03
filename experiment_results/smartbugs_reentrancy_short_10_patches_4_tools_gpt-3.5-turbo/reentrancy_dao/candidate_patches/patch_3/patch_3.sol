/*
 * @source: https://github.com/ConsenSys/evm-analyzer-benchmark-suite
 * @author: Suhabe 
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

// The repaired contract moves the statement "credit[msg.sender] = 0;" before the "balance -= oCredit;" statement. This prevents reentrancy attacks where an attacker can call the withdrawAll() function recursively to drain the contract's balance.