pragma solidity ^0.4.24;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check that there are rewards to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        bool success = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once
        claimedBonus[recipient] = true; // Mark the bonus as claimed before transferring rewards
        rewardsForA[recipient] = 100;
        withdrawReward(recipient); // Transfer rewards to recipient
    }
}