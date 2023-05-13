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

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;

        withdrawReward(recipient);
    }
} 

// Changes made:
// - Updated Solidity version to 0.8.0
// - Used the "payable" modifier to send ether to recipient in withdrawReward function
// - Moved claimedBonus[recipient] = true; above withdrawReward(recipient); to prevent reentrancy vulnerability