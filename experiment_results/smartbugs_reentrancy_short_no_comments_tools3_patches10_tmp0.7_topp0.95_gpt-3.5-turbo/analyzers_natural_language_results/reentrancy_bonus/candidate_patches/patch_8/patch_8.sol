pragma solidity ^0.5.0;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(amountToWithdraw > 0, "No reward to withdraw");
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success, "Reward withdrawal failed");
    }

    function getFirstWithdrawalBonus(address payable recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed"); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
}