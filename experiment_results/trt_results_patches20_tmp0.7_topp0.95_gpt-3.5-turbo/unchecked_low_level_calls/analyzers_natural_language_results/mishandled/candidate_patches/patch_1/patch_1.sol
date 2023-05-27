pragma solidity ^0.4.24;

contract SendBack {
    mapping(address => uint) userBalances;

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;

        require(msg.sender.send(amountToWithdraw));
    }
}