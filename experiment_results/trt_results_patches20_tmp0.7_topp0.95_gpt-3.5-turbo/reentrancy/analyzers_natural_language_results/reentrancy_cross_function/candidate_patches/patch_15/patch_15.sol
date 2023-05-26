pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if sender is already withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // check if sender has any balance

        locked[msg.sender] = true; // lock the sender to prevent reentrancy attack
        userBalances[msg.sender] = 0;

        bool success = msg.sender.send(amountToWithdraw); // transfer the balance
        require(success);

        locked[msg.sender] = false; // unlock the sender
    }
}