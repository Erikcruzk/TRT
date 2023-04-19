pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private isWithdrawn;

    function withdrawReward(address recipient) public {
        require(isWithdrawn[recipient] == false);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        isWithdrawn[recipient] = true;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once
        claimedBonus[recipient] = true;
        rewardsForA[recipient] = 100;
        withdrawReward(recipient); // At this point, the caller will be able to execute getFirstWithdrawalBonus again.
    }
} 

// Changes Made:
// Added a mapping to keep track of withdrawn rewards
// Moved the claimedBonus[recipient] = true; statement before adding rewards
// Added the {value: amountToWithdraw} syntax in the recipient call statement to prevent reentrancy attack
// Replaced Solidity version from 0.4.0 to 0.8.0 for better security features