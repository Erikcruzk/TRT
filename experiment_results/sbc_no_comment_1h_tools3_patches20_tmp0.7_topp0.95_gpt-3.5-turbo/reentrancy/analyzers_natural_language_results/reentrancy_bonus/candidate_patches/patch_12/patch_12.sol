pragma solidity ^0.4.0;

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
// 1. Moved the claimedBonus[recipient] assignment above the withdrawReward function call to prevent reentrancy vulnerability.
// 2. Changed the recipient.call.value(amountToWithdraw)("") to recipient.call.value(amountToWithdraw)() and added a require statement to handle any errors that may occur during the external call.