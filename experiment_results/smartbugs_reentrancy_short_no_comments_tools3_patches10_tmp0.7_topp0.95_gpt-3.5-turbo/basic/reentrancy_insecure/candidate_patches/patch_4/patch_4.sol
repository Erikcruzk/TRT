pragma solidity ^0.8.0;

contract Reentrancy_secure {

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        locked[msg.sender] = true;
        require(amountToWithdraw > 0, "Insufficient balance");
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
        locked[msg.sender] = false;
    }
}