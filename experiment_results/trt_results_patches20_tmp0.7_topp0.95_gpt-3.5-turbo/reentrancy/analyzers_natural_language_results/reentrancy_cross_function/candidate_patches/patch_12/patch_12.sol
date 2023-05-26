pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount);
        require(!locked[msg.sender] && !locked[to]);

        locked[msg.sender] = true;
        locked[to] = true;

        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;

        locked[msg.sender] = false;
        locked[to] = false;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];

        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;

        msg.sender.transfer(amountToWithdraw);

        locked[msg.sender] = false;
    }
}