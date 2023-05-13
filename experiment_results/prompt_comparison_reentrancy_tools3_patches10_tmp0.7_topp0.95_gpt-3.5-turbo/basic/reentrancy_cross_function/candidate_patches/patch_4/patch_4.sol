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
        userBalances[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }
}

// Changes Made:
// 1. Added function and parameter visibility keywords
// 2. Replaced if statement with require statement in the transfer function
// 3. Moved the userBalances[msg.sender] = 0; statement before the require statement in withdrawBalance function to prevent reentrancy attack. 
// 4. Replaced the call.value syntax with call.value(). This is because in the latest version of Solidity, call.value syntax is deprecated.