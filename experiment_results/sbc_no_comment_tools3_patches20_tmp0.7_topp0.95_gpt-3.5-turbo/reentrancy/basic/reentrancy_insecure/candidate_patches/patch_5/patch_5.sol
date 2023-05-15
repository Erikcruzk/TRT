pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Withdrawal is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");
        locked = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
        locked = false;
    }
} 

// The repaired contract includes a boolean variable 'locked' to prevent reentrancy attacks by locking the function during execution. The function also includes additional require statements to check for sufficient balance and successful execution of the withdrawal function. The syntax has also been updated to the latest version of Solidity.