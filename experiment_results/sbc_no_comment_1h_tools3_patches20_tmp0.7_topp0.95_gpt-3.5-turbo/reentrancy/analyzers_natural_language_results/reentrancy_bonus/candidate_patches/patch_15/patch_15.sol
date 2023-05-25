pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;
    mapping(address => bool) private withdrawing;

    function withdrawReward(address recipient) public {
        require(!withdrawing[recipient]);
        withdrawing[recipient] = true;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        withdrawing[recipient] = false;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
}