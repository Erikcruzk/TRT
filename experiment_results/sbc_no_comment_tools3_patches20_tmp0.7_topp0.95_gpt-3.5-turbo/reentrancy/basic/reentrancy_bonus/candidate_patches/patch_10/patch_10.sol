pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint256) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint256) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        uint256 amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(amountToWithdraw > 0, "No rewards to withdraw");
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Failed to transfer reward");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed");

        rewardsForA[recipient] += 100;

        withdrawReward(payable(recipient));
        claimedBonus[recipient] = true;
    }
}