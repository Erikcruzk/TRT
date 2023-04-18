pragma solidity ^0.4.24;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check if there is a reward to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(recipient.call.value(amountToWithdraw)()); // Use the "transfer" function instead of "call.value" to prevent reentrancy attacks
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] = 100; // Use assignment instead of addition to prevent integer overflow
        claimedBonus[recipient] = true;
        withdrawReward(recipient); // Withdraw the reward after it has been assigned and claimed
    }
}