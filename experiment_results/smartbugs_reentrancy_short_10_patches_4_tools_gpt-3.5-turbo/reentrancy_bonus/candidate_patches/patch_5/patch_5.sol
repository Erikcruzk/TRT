/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author: consensys
 * @vulnerable_at_lines: 28
 */

pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;
    bool private locked;

    function withdrawReward(address recipient) public {
        require(!locked, "Contract is locked");
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        locked = true;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success, "Transfer failed.");
        locked = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient], "Bonus already claimed");
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
} 

// Changes Made:
// 1. Added a bool variable 'locked' to prevent reentrancy attack.
// 2. Added a require statement in 'withdrawReward' function to check if the contract is locked.
// 3. Moved the 'claimedBonus' check to the beginning of 'getFirstWithdrawalBonus' function to prevent reentrancy attack.
// 4. Updated the syntax for transfer of ether.