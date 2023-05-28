pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) public {
        require(!locked[msg.sender]);
        require(userBalances[msg.sender] >= amount);
        locked[msg.sender] = true;
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
} 

// Changes made:
// 1. Added a "locked" mapping to prevent reentrancy attacks
// 2. Added require statements to ensure that the sender has sufficient balance and is not locked before executing transfer() and withdrawBalance() functions
// 3. Moved the state variable modification before the external call in withdrawBalance() function and added a require statement to ensure that the withdrawal amount is greater than 0 before sending the ether to the sender.