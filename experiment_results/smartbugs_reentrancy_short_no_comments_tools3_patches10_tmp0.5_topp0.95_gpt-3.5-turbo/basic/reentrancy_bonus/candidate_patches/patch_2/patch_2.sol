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

//Changes Made:
//1. Updated the solidity version to ^0.8.0.
//2. Removed the 'INSECURE' comment as it is unnecessary.
//3. Replaced 'recipient.call.value(amountToWithdraw)("")' with 'payable(recipient).send(amountToWithdraw)' to prevent reentrancy attack.
//4. Moved the 'claimedBonus[recipient] = true' statement before the 'withdrawReward(recipient)' statement to prevent multiple claims.