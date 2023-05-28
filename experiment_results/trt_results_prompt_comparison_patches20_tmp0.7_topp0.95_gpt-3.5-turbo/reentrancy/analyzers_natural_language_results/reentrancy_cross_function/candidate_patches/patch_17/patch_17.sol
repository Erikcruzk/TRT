pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        userBalances[msg.sender] = 0;
        bool success = msg.sender.send(amountToWithdraw);
        require(success);
    }
}

// Changes made:
// 1. Added "public" visibility specifier to transfer function to ensure it can be called externally.
// 2. Replaced if statement with require statement in transfer function to ensure that the condition is always true.
// 3. Added require statement to ensure that the user has a non-zero balance before withdrawing.
// 4. Moved userBalances[msg.sender] = 0; statement before the external call to prevent reentrancy attack.
// 5. Replaced call.value with send to prevent reentrancy attack.