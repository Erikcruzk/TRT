pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount); // added require statement to check if balance is sufficient
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // moved this line before the external call

        require(msg.sender.call.value(amountToWithdraw)()); // changed syntax for external call to prevent reentrancy attack
    }
}