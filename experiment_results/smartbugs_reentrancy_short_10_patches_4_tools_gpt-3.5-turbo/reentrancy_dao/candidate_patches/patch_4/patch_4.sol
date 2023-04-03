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
            require(msg.sender.call.value(oCredit)());
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// The repaired contract moves the line where the credit[msg.sender] is set to 0 to be before the balance -= oCredit; line. This ensures that the function call to msg.sender is the last operation in the function, preventing reentrancy attacks.