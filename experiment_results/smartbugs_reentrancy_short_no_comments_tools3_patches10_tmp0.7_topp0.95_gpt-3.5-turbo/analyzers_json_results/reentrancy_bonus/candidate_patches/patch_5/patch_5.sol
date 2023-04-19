pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(payable(recipient).send(amountToWithdraw));
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Each recipient should only be able to claim the bonus once

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
} 

// Fixed the vulnerability of reentrancy attack by moving the claimedBonus[recipient] = true line before the call to withdrawReward(recipient).
// Also fixed the vulnerability of integer overflow by upgrading the Solidity version to 0.8.0 and using the require(payable(recipient).send(amountToWithdraw)); syntax instead of the recipient.call.value(amountToWithdraw)(""); syntax.