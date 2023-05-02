pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        require(!locked[msg.sender]);

        locked[msg.sender] = true;
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0);
        require(!locked[msg.sender]);

        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
        locked[msg.sender] = false;
    }
}