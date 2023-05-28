pragma solidity ^0.4.0;

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
        locked[msg.sender] = true;

        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false;
    }
}