pragma solidity ^0.8.0;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private canWithdraw;

    function withdrawReward(address recipient) public {
        require(canWithdraw[recipient], "No rewards to withdraw");
        canWithdraw[recipient] = false;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed");
        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        canWithdraw[recipient] = true;
        withdrawReward(recipient);
    }
}