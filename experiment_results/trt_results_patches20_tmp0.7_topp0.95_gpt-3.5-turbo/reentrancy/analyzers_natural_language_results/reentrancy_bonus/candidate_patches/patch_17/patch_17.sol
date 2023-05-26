pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(recipient.call.value(amountToWithdraw)());
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
}

// Changes Made: 
// 1. Moved the claimBonus state variable to the top
// 2. Added a reentrancy guard by moving the state variable update to the top of the function
// 3. Updated the require statement in withdrawReward to include the return value of the call function
// 4. Reordered the function calls in getFirstWithdrawalBonus function to prevent reentrancy vulnerability.