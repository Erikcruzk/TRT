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
// 1. Added visibility modifier to transfer function
// 2. Added require statement to check for sufficient balance in transfer function
// 3. Moved userBalances[msg.sender] = 0; statement before the external call in withdrawBalance function
// 4. Added error messages to require and call statements in both functions
// 5. Updated pragma version to ^0.8.0