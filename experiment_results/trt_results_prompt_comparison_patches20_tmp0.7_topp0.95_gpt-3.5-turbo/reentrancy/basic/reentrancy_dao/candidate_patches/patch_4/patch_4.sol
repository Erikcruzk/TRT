pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0, "No credit to withdraw");
        credit[msg.sender] = 0;
        balance -= oCredit;

        (bool callResult, ) = msg.sender.call{value: oCredit}("");
        require(callResult, "Withdraw failed");
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made
// 1. Updated the Solidity version to 0.8.0
// 2. Added error messages using require() and customized them according to the context
// 3. Moved the credit[msg.sender] = 0; statement before the balance update to avoid reentrancy attack
// 4. Used the new syntax for calling external contracts with value.