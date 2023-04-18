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
        require(success, "Withdrawal failed");
    }
    
    function deposit() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
} 

// The repaired contract adds a mapping to track if a withdrawal is already in progress for a particular address. 
// It also adds additional checks to ensure that the balance is sufficient and that the withdrawal was successful. 
// Finally, the contract includes a deposit function and a function to check the user's balance.