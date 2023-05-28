pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true;
        rewardsForA[recipient] = 100;
        withdrawReward(recipient);
    }
} 

// Changes Made
// 1. Added a check in withdrawReward function to ensure that the amount to withdraw is greater than 0
// 2. Moved the claimedBonus[recipient] = true; statement before rewardsForA[recipient] = 100; statement in the getFirstWithdrawalBonus function to prevent reentrancy attack
// 3. Updated the syntax for the call function to use curly braces and include the "value" parameter.