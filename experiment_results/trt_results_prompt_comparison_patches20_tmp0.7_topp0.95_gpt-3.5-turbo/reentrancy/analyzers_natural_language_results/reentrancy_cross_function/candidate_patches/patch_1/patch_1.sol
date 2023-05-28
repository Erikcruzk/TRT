pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) {
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
// 1. Reordered the code in withdrawBalance() function to set userBalances[msg.sender] to 0 before making the external call to prevent reentrancy attack.
// 2. Added require statement in the transfer() function to check if user has enough balance before transferring it.