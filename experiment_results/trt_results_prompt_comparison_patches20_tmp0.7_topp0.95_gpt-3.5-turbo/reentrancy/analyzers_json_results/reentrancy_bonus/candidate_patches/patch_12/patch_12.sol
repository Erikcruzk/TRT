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
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
} 

//Changes Made:
//1. Moved claimedBonus[recipient] = true; above rewardsForA[recipient] += 100; to ensure that it is updated before any state change happens.
//2. Replaced (bool success, ) = recipient.call.value(amountToWithdraw)(""); with require(recipient.call.value(amountToWithdraw)()); to avoid reentrancy vulnerability.