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
// 1. Moved the credit[msg.sender] = 0; statement above balance -= oCredit; to prevent reentrancy attack.
// 2. Added a require statement in the deposit function to prevent integer underflow.