pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;

    function withdrawBalance() public {
        require(userBalances[msg.sender] > 0); // Check if user has balance to withdraw
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update user balance before sending funds to prevent reentrancy attack

        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
    }
}