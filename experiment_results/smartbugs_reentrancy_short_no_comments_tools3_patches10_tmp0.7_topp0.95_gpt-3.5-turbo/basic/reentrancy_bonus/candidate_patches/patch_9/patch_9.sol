pragma solidity ^0.8.0;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private withdrawalStatus;

    function withdrawReward(address recipient) public {
        require(withdrawalStatus[recipient] == false, "Already withdrew reward");
        withdrawalStatus[recipient] = true;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Reward withdrawal failed");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed");
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
} 

// Changes made:
// - Added a new mapping called withdrawalStatus to keep track of whether a user has already withdrawn their reward or not
// - Added a require statement in withdrawReward function to check if the user has already withdrawn their reward
// - Moved the claimedBonus[recipient] = true; statement before the rewardsForA[recipient] += 100; statement to prevent reentrancy attack
// - Updated the syntax for function call to use the latest Solidity version syntax.