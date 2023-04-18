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

// Changes made:
// 1. Removed the INSECURE comment as it is unnecessary and misleading.
// 2. Updated the pragma version to 0.8.0 to use the latest version of Solidity.
// 3. Changed the recipient.call.value() to payable(recipient).send() to prevent reentrancy attacks.
// 4. Moved the claimedBonus[recipient] assignment before the withdrawReward() function call to prevent reentrancy attacks.