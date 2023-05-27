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
// 1. Updated Solidity version to 0.4.24
// 2. Removed unnecessary parentheses in withdrawReward function call
// 3. Moved claimedBonus[recipient] = true; before rewardsForA[recipient] += 100; to prevent reentrancy attack by ensuring that claimedBonus is set before any balance update is made.