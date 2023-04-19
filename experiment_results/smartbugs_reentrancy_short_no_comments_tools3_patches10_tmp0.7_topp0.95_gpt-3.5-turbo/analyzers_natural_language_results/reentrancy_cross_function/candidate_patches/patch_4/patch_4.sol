pragma solidity ^0.4.0;

contract Reentrancy_cross_function {

    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) {
        require(userBalances[msg.sender] >= amount); // Check if the sender has enough balance
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update balance before external call
        (bool success, ) = msg.sender.call.value(amountToWithdraw)(""); // External call after updating balance
        require(success);
    }
}