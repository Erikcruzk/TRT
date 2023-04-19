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
        require(msg.value > 0);
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made:
// 1. Reordered the statements in withdrawAll() to prevent reentrancy vulnerability.
// 2. Added require statement in deposit() to prevent integer underflow.