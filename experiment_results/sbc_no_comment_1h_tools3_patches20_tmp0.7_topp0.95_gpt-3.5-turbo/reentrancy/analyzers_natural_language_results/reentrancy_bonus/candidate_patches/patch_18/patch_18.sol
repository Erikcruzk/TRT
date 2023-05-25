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

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
}

// Changes Made:
// 1. Updated pragma version to ^0.4.24
// 2. Updated the call function in withdrawReward to use the new syntax (require(recipient.call.value(amountToWithdraw)());)
// 3. Moved the update of claimedBonus mapping before calling withdrawReward function to prevent reentrancy vulnerability.