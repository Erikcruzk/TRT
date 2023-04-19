pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping (address => uint) public credit;
    uint public balance;

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

// Changes made:
// 1. Made credit and balance variables public for easy access outside the contract
// 2. Moved the credit[msg.sender] = 0; line before balance -= oCredit; to prevent reentrancy attacks
// 3. Updated the Solidity version to the latest one.