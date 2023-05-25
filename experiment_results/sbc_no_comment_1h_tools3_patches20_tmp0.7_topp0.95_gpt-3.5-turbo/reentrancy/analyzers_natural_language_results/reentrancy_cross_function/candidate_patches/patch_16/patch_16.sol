pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lockedAccounts;

    function transfer(address to, uint amount) public {
        require(!lockedAccounts[msg.sender]);
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!lockedAccounts[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        lockedAccounts[msg.sender] = true;
        require(msg.sender.call.value(amountToWithdraw)());
        lockedAccounts[msg.sender] = false;
    }
}