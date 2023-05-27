pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) public credit;
    uint public balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0, "You do not have any credits to withdraw.");
        credit[msg.sender] = 0;
        balance -= oCredit;
        
        (bool callResult, ) = msg.sender.call{value: oCredit}("");
        require(callResult, "Withdrawal failed");
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}

// Changes Made:
// 1. Updated the solidity version to ^0.8.0 to use the latest version.
// 2. Made the credit and balance variables public to allow easy access from outside the contract.
// 3. Added a require statement to check if the user has any credits to withdraw.
// 4. Moved the credit[msg.sender] = 0; statement before balance -= oCredit; to prevent reentrancy attacks.
// 5. Updated the transfer method to call() to prevent reentrancy attacks.