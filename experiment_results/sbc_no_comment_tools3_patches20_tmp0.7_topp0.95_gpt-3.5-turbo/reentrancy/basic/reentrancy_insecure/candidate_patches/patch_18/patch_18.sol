pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Withdrawals are locked.");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "You have no balance to withdraw.");

        locked = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed.");
        locked = false;
    }

    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }

    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawAll() public {
        require(!locked, "Withdrawals are locked.");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "You have no balance to withdraw.");

        locked = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed.");
        locked = false;
    }
} 

// The repaired smart contract has added a 'locked' boolean variable to prevent reentrancy attacks. 
// The 'withdrawBalance' function has been updated to check if there is a balance to withdraw before locking the contract and executing the withdrawal. 
// Two additional functions have also been added: 'getBalance' to check the user's balance, and 'withdrawAll' to withdraw all available funds. 
// These changes help to prevent reentrancy attacks by ensuring that only one withdrawal can be made at a time and by checking for available funds before executing a withdrawal.