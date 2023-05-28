pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount); // Check if sender has enough balance
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0); // Check if sender has balance to withdraw
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw); // Use transfer() instead of call.value() for security
    }
}