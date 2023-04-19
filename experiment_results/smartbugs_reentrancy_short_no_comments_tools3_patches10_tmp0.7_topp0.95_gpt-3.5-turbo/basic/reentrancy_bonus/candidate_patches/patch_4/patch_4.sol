pragma solidity ^0.4.24;

contract Reentrancy_bonus{

    // FIXED: Added "public" to ensure visibility
    mapping (address => uint) public userBalances;
    mapping (address => bool) public claimedBonus;
    mapping (address => uint) public rewardsForA;

    // FIXED: Use of "transfer" instead of "call.value" to prevent reentrancy attacks
    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(amountToWithdraw > 0);
        recipient.transfer(amountToWithdraw);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient); // FIXED: Withdrawal is now called after the claimedBonus flag is set
    }
}