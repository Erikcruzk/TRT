pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
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

// Changes Made:
// Reordered the sequence of operations in the withdrawAll function to update the credit before transferring funds to prevent reentrancy attack. 
// Moved the call to an external contract (msg.sender.call()) to the end of the function after all state changes have been made.
// Removed unnecessary variable "callResult". 
// Also, updated the Solidity version to the latest compatible version.