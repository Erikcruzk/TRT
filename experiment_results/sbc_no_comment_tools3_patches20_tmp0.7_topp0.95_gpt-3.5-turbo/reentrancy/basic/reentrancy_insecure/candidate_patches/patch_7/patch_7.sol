pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private isWithdrawn;

    function withdrawBalance() public {
        require(!isWithdrawn[msg.sender], "Already withdrawn");
        uint amountToWithdraw = userBalances[msg.sender];
        isWithdrawn[msg.sender] = true;
        userBalances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
    }
} 

//Changes Made:
//1. Updated solidity version to 0.8.0 to use newer syntax.
//2. Added a mapping to track if a user has already withdrawn their balance or not.
//3. Added a check to ensure that the user has not already withdrawn their balance.
//4. Moved the update of the isWithdrawn mapping and zeroing of the user's balance before the external call to prevent reentrancy attacks.
//5. Added a require statement to check if the external call was successful.