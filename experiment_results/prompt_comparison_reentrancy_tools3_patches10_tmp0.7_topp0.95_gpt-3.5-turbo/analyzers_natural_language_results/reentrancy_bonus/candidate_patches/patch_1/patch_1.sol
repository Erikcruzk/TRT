pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // added check to prevent withdrawing 0 or negative amounts
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        bool success = false; // changed to bool variable instead of tuple
        bytes memory returnData;
        (success, returnData) = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true; // moved this line up to prevent reentrancy vulnerability

        withdrawReward(recipient);
    }
}