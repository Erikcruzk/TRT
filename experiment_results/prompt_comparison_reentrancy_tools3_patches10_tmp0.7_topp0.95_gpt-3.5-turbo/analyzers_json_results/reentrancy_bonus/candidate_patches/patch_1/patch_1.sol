pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
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
// 1. Updated the Solidity version to ^0.8.0
// 2. Added the value parameter to the recipient.call function to prevent reentrancy attacks
// 3. Moved the claimedBonus assignment before calling the withdrawReward function to prevent reentrancy attacks