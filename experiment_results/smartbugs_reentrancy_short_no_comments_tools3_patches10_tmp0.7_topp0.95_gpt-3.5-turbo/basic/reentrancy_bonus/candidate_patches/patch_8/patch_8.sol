pragma solidity ^0.4.24;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private withdrawalStatus; // Added to track withdrawal status of each user

    function withdrawReward(address recipient) public {
        require(withdrawalStatus[recipient] == false); // Check if user has already withdrawn
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        withdrawalStatus[recipient] = true; // Mark user as withdrawn
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once
        require(withdrawalStatus[recipient] == false); // User should not have withdrawn before

        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
        claimedBonus[recipient] = true;
    }
}