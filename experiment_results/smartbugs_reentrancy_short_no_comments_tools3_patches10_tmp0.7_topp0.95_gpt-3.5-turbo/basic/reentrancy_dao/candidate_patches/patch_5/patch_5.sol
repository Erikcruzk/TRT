pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping (address => uint) public credit;
    uint public balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            balance -= oCredit;
            credit[msg.sender] = 0;
            (bool callResult, ) = msg.sender.call{value: oCredit}("");
            require(callResult, "Error: Call failed");
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Made the credit and balance variables public to allow external access
// 3. Added error message to require statement to provide more context
// 4. Moved the state changes before the external call to prevent reentrancy attacks.