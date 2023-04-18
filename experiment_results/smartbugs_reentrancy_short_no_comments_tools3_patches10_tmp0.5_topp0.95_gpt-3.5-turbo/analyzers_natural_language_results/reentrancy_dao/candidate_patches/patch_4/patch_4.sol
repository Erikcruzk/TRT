pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping (address => uint) credit;
    uint balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        if (oCredit > 0) {
            credit[msg.sender] = 0;
            balance -= oCredit;
            (bool callResult, ) = msg.sender.call{value: oCredit}("");
            require (callResult, "External call failed");
        }
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}

// Changes made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Moved the state variable modification before the external call in the withdrawAll function to prevent reentrancy attacks
// 3. Added a return value to the external call and used the tuple syntax to ignore the second return value
// 4. Added an error message to the require statement in the withdrawAll function to provide more information in case of failure.