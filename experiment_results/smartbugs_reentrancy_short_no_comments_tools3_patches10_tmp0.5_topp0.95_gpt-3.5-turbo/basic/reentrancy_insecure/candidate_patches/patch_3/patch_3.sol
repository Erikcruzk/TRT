pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdrawal already in progress");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
    }
    
    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// Changes Made
// 1. Added a 'locked' mapping to prevent reentrancy attacks
// 2. Added a check to ensure that the user has sufficient balance before withdrawal
// 3. Moved the withdrawal function call to the end of the function to prevent reentrancy attacks
// 4. Added a deposit function to allow users to add funds to their balance
// 5. Added a getBalance function to allow users to check their balance.