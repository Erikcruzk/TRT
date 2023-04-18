pragma solidity ^0.4.24;

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }
}

// Changes Made:
// 1. Added "public" keyword to transfer function.
// 2. Replaced if statement with require statement in transfer function.
// 3. Moved userBalances[msg.sender] = 0; statement before the require statement in withdrawBalance function.