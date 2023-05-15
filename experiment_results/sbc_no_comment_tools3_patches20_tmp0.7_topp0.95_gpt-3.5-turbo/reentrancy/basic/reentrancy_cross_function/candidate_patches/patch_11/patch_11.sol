pragma solidity ^0.4.24;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount); // add require statement
        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0; // update state before external call

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
    }
}