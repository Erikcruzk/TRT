pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;
    bool private locked;

    function withdrawReward(address recipient) public {
        require(!locked); // added reentrancy guard
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        locked = true; // set lock before external call
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        locked = false; // release lock after external call
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient); // moved after setting claimedBonus
    }
}