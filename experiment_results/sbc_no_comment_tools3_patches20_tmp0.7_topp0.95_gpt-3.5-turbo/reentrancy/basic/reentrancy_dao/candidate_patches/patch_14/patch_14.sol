pragma solidity ^0.8.0;

contract ReentrancyDAO {
    mapping(address => uint) public credit;
    uint public balance;

    function withdrawAll() public {
        uint oCredit = credit[msg.sender];
        require(oCredit > 0, "Insufficient credit balance.");
        credit[msg.sender] = 0;
        balance -= oCredit;
        (bool success, ) = msg.sender.call{value: oCredit}("");
        require(success, "Withdrawal failed.");
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
} 

// Changes Made
// 1. Updated the solidity version to ^0.8.0
// 2. Made the credit and balance variables public to ensure transparency
// 3. Moved the credit[msg.sender] = 0; statement before balance -= oCredit; to prevent reentrancy attacks
// 4. Added require statement to check if the user has sufficient credit balance before withdrawing
// 5. Updated the transfer function to call{value: }("") to prevent reentrancy attacks
// 6. Added error messages to the require statements for better debugging