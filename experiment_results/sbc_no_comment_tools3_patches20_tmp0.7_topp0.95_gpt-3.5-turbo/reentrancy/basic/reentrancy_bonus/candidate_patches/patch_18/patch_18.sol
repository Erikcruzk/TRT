pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // add check for non-zero rewards
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(recipient.call.value(amountToWithdraw)()); // update deprecated call function
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient); // move function call to after setting claimedBonus to true
    }
}