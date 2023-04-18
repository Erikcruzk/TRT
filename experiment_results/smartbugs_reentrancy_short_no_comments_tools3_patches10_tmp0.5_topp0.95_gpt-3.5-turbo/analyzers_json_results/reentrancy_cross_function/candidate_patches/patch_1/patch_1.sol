pragma solidity ^0.8.0;

contract Reentrancy_cross_function {
    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
    }
} 

// Changes made:
// 1. Added visibility specifier to the transfer function.
// 2. Added require statement to check for sufficient balance before transfer.
// 3. Moved the userBalances[msg.sender] = 0; statement before the external call to prevent reentrancy attack.
// 4. Changed the external call syntax to the current recommended syntax. 
// 5. Added require statement to check if the external call was successful.