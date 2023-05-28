pragma solidity ^0.5.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(amountToWithdraw > 0, "No reward balance to withdraw.");
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success, "Reward withdrawal failed.");
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed.");

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(msg.sender);
    }
}