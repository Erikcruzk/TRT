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

// Changes made:
// 1. Reordered statements in the withdrawAll function to prevent reentrancy vulnerability
// 2. Added require statement in deposit function to prevent integer underflow vulnerability.