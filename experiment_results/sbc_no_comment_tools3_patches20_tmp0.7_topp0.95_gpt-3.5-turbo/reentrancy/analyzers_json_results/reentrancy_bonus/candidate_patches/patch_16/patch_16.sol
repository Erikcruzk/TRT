pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check that there are rewards to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(recipient.call.value(amountToWithdraw)()); // Use the "()" syntax instead of empty string to avoid reentrancy issues
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true; // Set flag before calling external function

        rewardsForA[recipient] += 100;

        withdrawReward(recipient);
    }
}