/*
 * @source: https://github.com/ConsenSys/evm-analyzer-benchmark-suite
 * @author: Suhabe
 * @fixed_by: [Your Name]
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
            // <yes> <report> REENTRANCY
            bool callResult = msg.sender.call.value(oCredit)();
            require (callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// The repair is to move the line "credit[msg.sender] = 0;" before the line "balance -= oCredit;" in the withdrawAll() function. This ensures that the credit of the user is set to 0 before the balance is updated and the external call is made. This prevents reentrancy attacks where an attacker can repeatedly call the withdrawAll() function and drain the contract's balance.