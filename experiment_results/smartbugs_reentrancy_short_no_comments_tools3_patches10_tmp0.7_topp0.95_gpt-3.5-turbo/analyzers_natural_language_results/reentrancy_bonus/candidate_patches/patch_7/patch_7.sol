pragma solidity ^0.4.0;

contract Reentrancy_bonus{

    // FIXED: added a mutex to prevent reentrancy attack
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    bool private locked;

    function withdrawReward(address recipient) public {
        require(!locked);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        locked = true;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        locked = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient); // FIXED: withdraw reward after setting claimedBonus to true
    }
}