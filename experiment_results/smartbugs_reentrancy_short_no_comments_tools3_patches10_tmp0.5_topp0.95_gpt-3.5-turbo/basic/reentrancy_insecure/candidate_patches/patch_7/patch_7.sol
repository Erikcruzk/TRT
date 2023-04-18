pragma solidity ^0.8.0;

contract Reentrancy_secure {

    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdrawal already in progress");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
    }
}