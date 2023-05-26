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

// Changes Made
// Reordered lines in getFirstWithdrawalBonus to set claimedBonus before calling withdrawReward
// Changed the call function in withdrawReward to use require instead of a tuple with a success bool, which is deprecated in Solidity 0.4.24.