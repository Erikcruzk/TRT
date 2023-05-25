pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(payable(recipient).send(amountToWithdraw));
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
}

// Changes Made:
// 1. Updated the solidity version to 0.8.0
// 2. Used the "payable" keyword while sending ether to an address.
// 3. Moved the "claimedBonus[recipient] = true;" statement before adding the reward value.
// 4. Changed the order of statements in getFirstWithdrawalBonus() to prevent reentrancy vulnerability.