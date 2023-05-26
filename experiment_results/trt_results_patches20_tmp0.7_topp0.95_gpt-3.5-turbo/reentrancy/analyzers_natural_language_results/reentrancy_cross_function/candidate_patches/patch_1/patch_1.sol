pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender], "Reentrancy attack detected");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");

        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;

        require(msg.sender.call.value(amountToWithdraw)(), "Failed to send Ether");

        locked[msg.sender] = false;
    }
}