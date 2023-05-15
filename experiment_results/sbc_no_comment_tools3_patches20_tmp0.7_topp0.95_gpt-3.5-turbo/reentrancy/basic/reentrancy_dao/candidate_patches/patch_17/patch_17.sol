pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            balance -= oCredit;

            (bool callResult, ) = msg.sender.call{value: oCredit}("");
            require(callResult);
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made
// 1. Updated compiler version to 0.8.0
// 2. Added visibility modifier to functions
// 3. Reordered statements in withdrawAll function to prevent reentrancy attack
// 4. Used the new syntax for calling external contracts to prevent reentrancy attack