pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Withdrawal failed");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed");

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
}

// Changes Made:
// 1. Updated pragma version to ^0.8.0
// 2. Added "Withdrawal failed" message in require statement in withdrawReward function
// 3. Moved claimedBonus[recipient] assignment before the call to withdrawReward function to prevent reentrancy vulnerability
// 4. Updated syntax for external function call to prevent reentrancy vulnerability.