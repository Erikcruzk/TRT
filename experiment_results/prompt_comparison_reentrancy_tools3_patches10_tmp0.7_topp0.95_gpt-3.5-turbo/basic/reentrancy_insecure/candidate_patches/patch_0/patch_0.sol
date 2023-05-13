pragma solidity ^0.6.0;

contract Reentrancy_insecure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Contract locked");
        locked = true;
        
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "Insufficient balance");

        userBalances[msg.sender] = 0;
        locked = false;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success, "Transfer failed");
    }
} 

// Changes made: 
// 1. Updated Solidity version
// 2. Added a bool variable to prevent reentrancy attacks
// 3. Added a check to ensure that the user has a balance before withdrawing
// 4. Moved the update of the user's balance to after the check to prevent reentrancy attacks
// 5. Added a check for the success of the transfer after calling the external contract.