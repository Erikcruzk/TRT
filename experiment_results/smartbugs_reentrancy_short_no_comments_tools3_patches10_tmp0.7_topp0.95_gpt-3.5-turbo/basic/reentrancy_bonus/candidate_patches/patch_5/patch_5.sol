pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        require(rewardsForA[recipient] > 0, "No rewards to withdraw");
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Failed to transfer funds");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed"); 
        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(payable(recipient));
    }
}