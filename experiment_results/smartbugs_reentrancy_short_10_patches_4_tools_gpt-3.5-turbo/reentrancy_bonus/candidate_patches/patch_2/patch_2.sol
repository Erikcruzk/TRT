/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @fixed_by: clevercontract
 */

pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    mapping (address => bool) private withdrawnRewards;

    function withdrawReward(address recipient) public {
        require(withdrawnRewards[recipient] == false, "Reward already withdrawn");
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        withdrawnRewards[recipient] = true;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed");
        require(withdrawnRewards[recipient] == false, "Reward already withdrawn");

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
} 

// Changes Made:
// 1. Added a mapping to track if rewards have already been withdrawn by a user
// 2. Added a check to ensure that rewards can only be withdrawn once per user
// 3. Added error messages to provide more information to the user
// 4. Updated the Solidity version to 0.8.0 and fixed the syntax of the call function.