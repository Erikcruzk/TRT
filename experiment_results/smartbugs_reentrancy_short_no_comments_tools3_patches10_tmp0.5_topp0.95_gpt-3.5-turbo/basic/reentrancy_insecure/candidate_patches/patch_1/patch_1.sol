pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw already in progress");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
    }
    
    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// The repaired contract includes a locking mechanism to prevent reentrancy attacks. 
// It also includes additional functions for depositing and checking balances.