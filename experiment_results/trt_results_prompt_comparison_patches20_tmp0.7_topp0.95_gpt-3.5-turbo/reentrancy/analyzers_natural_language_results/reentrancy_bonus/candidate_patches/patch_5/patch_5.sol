pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check if recipient has any rewards to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        bool success = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Check if recipient has already claimed the bonus

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;

        withdrawReward(recipient);
    }
}