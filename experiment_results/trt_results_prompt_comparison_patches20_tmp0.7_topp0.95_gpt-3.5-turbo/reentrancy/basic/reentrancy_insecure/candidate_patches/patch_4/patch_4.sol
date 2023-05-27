pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lockedAccounts;

    function withdrawBalance() public {
        require(!lockedAccounts[msg.sender], "Account is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        lockedAccounts[msg.sender] = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
        
        userBalances[msg.sender] = 0;
        lockedAccounts[msg.sender] = false;
    }
}