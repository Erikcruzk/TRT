pragma solidity ^0.4.24;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private reentrancyLock;

    function withdrawBalance() public {
        require(!reentrancyLock[msg.sender], "Reentrant call detected");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        reentrancyLock[msg.sender] = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success, "Withdrawal failed");
        userBalances[msg.sender] = 0;
        reentrancyLock[msg.sender] = false;
    }
}