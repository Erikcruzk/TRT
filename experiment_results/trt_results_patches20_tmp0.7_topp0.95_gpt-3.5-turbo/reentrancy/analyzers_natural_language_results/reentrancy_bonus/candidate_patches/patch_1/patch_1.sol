pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        bool success = false;
        if (recipient.call.value(amountToWithdraw)("")) {
            success = true;
        }
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
}

// Changes made:
// - Added require statement to check rewardsForA[recipient] > 0 to prevent reentrancy attack
// - Replaced (bool success, ) with bool success and if statement to handle external call and check for success
// - Moved claimedBonus[recipient] = true; before withdrawReward(recipient); to prevent reentrancy attack