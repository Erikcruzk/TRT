pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        require(!locked[msg.sender]);
        
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(userBalances[msg.sender] > 0);
        require(!locked[msg.sender]);
        
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;

        bool success = msg.sender.send(amountToWithdraw);
        require(success);

        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
    }
}