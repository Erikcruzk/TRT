pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount); // Add a require statement to check if the sender has enough balance
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update the user balance before transferring the funds to prevent reentrancy attack

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
}