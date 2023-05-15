pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender], "Withdraw already in progress");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");
        locked[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
        locked[msg.sender] = false;
    }
} 

// The repaired contract includes a new mapping called 'locked' which ensures that a user can only withdraw their balance once at a time. This prevents reentrancy attacks where the attacker repeatedly calls the 'withdrawBalance' function before the balance is updated. Additionally, the require statement checks that the user has a positive balance before attempting to withdraw. Finally, the withdrawal is wrapped in a require statement to check if the withdrawal was successful.