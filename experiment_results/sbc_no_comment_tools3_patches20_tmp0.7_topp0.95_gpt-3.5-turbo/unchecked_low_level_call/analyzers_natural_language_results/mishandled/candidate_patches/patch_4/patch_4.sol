pragma solidity ^0.4.0;

contract SendBack {
    mapping(address => uint) userBalances;

    function withdrawBalance() {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        require(msg.sender.send(amountToWithdraw)); // check return value of send()

    }
}