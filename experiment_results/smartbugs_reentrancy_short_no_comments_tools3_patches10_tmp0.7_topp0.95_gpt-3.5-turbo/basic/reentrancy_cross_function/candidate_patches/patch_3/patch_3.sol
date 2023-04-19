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

// Changes made:
// 1. Made the transfer function public
// 2. Added a require statement to check if the sender has sufficient balance to transfer the amount
// 3. Moved the userBalances[msg.sender] = 0; statement above the require statement in the withdrawBalance function to prevent reentrancy attacks
// 4. Changed the call.value() syntax to call.value()() to follow the latest Solidity syntax.