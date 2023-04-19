pragma solidity ^0.4.24;

contract Reentrancy_bonus{

    // SECURE
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private withdrawing;

    function withdrawReward(address recipient) public {
        require(!withdrawing[recipient]); // Prevent re-entrancy attack
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        withdrawing[recipient] = true;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        withdrawing[recipient] = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient); // Withdraw after setting claimedBonus
    }
}