pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private lockedAccounts;

    function transfer(address to, uint amount) public {
        require(userBalances[msg.sender] >= amount, "Insufficient balance.");
        require(!lockedAccounts[msg.sender], "Account is locked.");

        userBalances[to] += amount;
        userBalances[msg.sender] -= amount;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw.");
        require(!lockedAccounts[msg.sender], "Account is locked.");

        lockedAccounts[msg.sender] = true;
        userBalances[msg.sender] = 0;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success, "Failed to transfer funds.");

        lockedAccounts[msg.sender] = false;
    }
}