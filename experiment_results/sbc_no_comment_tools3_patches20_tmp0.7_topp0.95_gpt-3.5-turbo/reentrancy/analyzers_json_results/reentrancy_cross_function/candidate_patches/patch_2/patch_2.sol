pragma solidity ^0.4.0;

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
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
} 

// Changes made:
// 1. Added "public" to the transfer function to make it accessible from outside the contract.
// 2. Used require statement instead of if statement in the transfer function to handle insufficient balance.
// 3. Moved the userBalances state variable update before the external call in the withdrawBalance function to prevent reentrancy attack.
// 4. Reordered the success and value variables in the call function to comply with the latest Solidity version.