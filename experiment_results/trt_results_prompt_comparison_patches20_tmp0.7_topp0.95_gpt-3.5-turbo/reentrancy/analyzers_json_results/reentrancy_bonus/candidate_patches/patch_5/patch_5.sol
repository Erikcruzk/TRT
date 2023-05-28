pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;
    bool private reentrancyLock = false;

    function withdrawReward(address recipient) public {
        require(!reentrancyLock);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        reentrancyLock = true;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        reentrancyLock = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
}