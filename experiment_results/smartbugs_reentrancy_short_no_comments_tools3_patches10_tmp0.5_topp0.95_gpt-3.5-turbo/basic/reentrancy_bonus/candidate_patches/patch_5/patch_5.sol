pragma solidity ^0.4.24;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private withdrawalInProgress;

    function withdrawReward(address recipient) public {
        require(!withdrawalInProgress[recipient]); // Prevent reentrancy
        withdrawalInProgress[recipient] = true;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        withdrawalInProgress[recipient] = false;
        require(recipient.send(amountToWithdraw)); // Use send instead of call
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once
        claimedBonus[recipient] = true;
        rewardsForA[recipient] = 100;
        withdrawReward(recipient);
    }
}