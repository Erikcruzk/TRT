pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            balance -= oCredit;

            (bool callResult,) = msg.sender.call{value: oCredit}("");
            require(callResult, "Call failed");
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Changed the syntax of the call function to be more secure and added an empty return variable to fix compilation error
// 3. Moved the credit[msg.sender] = 0; statement before balance -= oCredit; to prevent reentrancy attacks
// 4. Added an error message to the require statement to provide more information in case of failure.