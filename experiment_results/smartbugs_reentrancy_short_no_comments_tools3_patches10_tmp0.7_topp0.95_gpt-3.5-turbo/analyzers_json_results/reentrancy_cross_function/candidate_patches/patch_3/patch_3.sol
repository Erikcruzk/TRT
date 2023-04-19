pragma solidity ^0.8.0;

contract Reentrancy_cross_function {
    mapping (address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
    }
} 

// The repaired contract includes require statements to check for sufficient balance in the transfer function and adds the "public" modifier to the transfer function. It also moves the state variable update before the external call in the withdrawBalance function and adds a require statement to check for successful withdrawal.