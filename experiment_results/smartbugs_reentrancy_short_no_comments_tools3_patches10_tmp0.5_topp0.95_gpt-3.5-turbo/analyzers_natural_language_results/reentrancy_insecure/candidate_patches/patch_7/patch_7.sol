pragma solidity ^0.8.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private isWithdrawn;

    function withdrawBalance() public {
        require(!isWithdrawn[msg.sender], "Withdrawal already in progress");
        isWithdrawn[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
        isWithdrawn[msg.sender] = false;
    }
}