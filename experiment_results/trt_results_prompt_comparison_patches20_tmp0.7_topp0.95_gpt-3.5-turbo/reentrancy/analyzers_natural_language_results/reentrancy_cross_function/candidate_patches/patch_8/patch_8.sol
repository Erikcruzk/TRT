pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function transfer(address to, uint amount) {
        require(userBalances[msg.sender] >= amount);
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        require(!locked[msg.sender]); // check if the user is not already withdrawing
        locked[msg.sender] = true; // set the user as withdrawing
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // set user's balance to zero before the external call

        require(msg.sender.call.value(amountToWithdraw)()); // perform the external call

        locked[msg.sender] = false; // reset the user's withdrawing status
    }
}