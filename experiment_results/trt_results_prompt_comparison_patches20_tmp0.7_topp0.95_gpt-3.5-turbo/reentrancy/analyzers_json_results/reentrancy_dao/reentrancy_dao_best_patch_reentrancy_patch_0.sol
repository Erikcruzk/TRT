pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0; // Update credit before sending funds
            balance -= oCredit;

            bool callResult = msg.sender.call.value(oCredit)();
            require(callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made:
// 1. Moved the line "credit[msg.sender] = 0;" before sending funds to prevent reentrancy attack.