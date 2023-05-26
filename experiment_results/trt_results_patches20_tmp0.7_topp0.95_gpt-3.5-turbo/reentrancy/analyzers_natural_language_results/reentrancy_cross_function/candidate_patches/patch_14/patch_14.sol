pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lock;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!lock[msg.sender]);

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        lock[msg.sender] = true;
        msg.sender.transfer(amountToWithdraw);
        lock[msg.sender] = false;
    }
}