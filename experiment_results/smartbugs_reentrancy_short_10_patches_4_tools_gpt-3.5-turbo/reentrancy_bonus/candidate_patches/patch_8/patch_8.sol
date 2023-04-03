/*
 * @source: https://consensys.github.io/smart-contract-best-practices/known_attacks/
 * @author:
 * @vulnerable_at_lines: 28
 * @fixed_at_lines: 18, 24, 29
 */

pragma solidity ^0.8.0;

contract Reentrancy_bonus{
    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(payable(recipient).send(amountToWithdraw)); // use send instead of call
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once
        claimedBonus[recipient] = true; // mark bonus as claimed before sending to prevent reentrancy

        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
}