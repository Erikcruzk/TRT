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

// The repaired contract adds a require statement to check if the user has enough balance before transferring funds. It also moves the state variable modification before the external call in the withdrawBalance function to prevent reentrancy attacks.