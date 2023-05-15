pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount); // Add a require statement to ensure sender has enough balance
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // Update balance before sending ether to prevent reentrancy attacks

        require(msg.sender.call.value(amountToWithdraw)()); // Use the latest version of call function to prevent reentrancy attacks
    }
}