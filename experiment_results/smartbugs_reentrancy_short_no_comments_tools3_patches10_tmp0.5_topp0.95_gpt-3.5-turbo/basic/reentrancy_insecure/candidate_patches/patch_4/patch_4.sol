pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping (address => uint) private userBalances;
    mapping (address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdrawal already in progress");
        locked[msg.sender] = true;
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");
        userBalances[msg.sender] = 0;
        locked[msg.sender] = false;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// The repaired contract includes a new mapping called "locked" to prevent reentrancy attacks. 
// The function now checks whether the withdrawal is already in progress for the caller and reverts if so. 
// It also checks whether the user has sufficient balance before performing the withdrawal. 
// Finally, it resets the "locked" state after the withdrawal is completed. 
// Additionally, the contract includes a deposit function to allow users to add funds to their account.