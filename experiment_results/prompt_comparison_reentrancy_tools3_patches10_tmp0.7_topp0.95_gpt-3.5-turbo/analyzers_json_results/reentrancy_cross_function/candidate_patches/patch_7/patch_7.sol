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
        require(!locked[msg.sender]); // check if the user is already withdrawing funds
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true; // lock the user to prevent reentrancy attack

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false; // unlock the user after successful withdrawal
    }
}