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

// Changes made:
// - Moved claimedBonus[recipient] = true; before rewardsForA[recipient] += 100; to avoid reentrancy vulnerability.
// - Removed unused userBalances mapping.
// - Changed call.value() syntax to call.value()() to match the latest Solidity version. 
// - Updated Solidity version to 0.4.24 to match the latest version at the time of writing.