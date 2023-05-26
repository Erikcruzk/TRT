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

// Changes made:
// 1. Moved the update of claimedBonus before the external call to withdrawReward to prevent reentrancy vulnerability.
// 2. Changed the (bool success, ) syntax to require(recipient.call.value(amountToWithdraw)()) for better readability and security.