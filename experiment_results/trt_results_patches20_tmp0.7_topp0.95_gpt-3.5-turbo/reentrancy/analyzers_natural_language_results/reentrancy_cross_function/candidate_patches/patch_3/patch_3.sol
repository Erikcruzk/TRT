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
        require(!locked[msg.sender], "Already locked");

        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success, "Withdrawal failed");
    }
}