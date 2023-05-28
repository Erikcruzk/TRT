pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked[msg.sender] = false;
    }
} 

//Explanation of changes made:
//1. Added a new mapping 'locked' to keep track of whether a user is already in the withdraw function to prevent reentrancy.
//2. Added a require statement to check if the user is already locked in the withdraw function to prevent reentrancy.
//3. Moved the line 'userBalances[msg.sender] = 0;' above the external call to prevent reentrancy attack. 
//4. Added the line 'locked[msg.sender] = false;' after the external call to unlock the user.