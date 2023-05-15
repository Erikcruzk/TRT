pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check that the user has rewards to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // Use msg.sender instead of recipient to prevent reentrancy
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true; // Set claimedBonus to true before adding rewards to prevent reentrancy

        rewardsForA[recipient] += 100;

        withdrawReward(recipient);
    }
}