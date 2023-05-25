pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) {
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if already locked
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update state before external call
        locked[msg.sender] = true; // lock the function

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false; // unlock the function
    }
}