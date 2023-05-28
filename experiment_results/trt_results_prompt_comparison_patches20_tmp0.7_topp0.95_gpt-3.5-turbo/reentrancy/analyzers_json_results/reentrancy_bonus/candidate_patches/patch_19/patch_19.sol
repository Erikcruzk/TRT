pragma solidity ^0.5.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        require(rewardsForA[recipient] > 0); // Check if recipient has any rewards
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // Check if recipient has claimed the bonus

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(msg.sender);
    }
} 

// The changes made are as follows:
// 1. Added "payable" keyword to the recipient argument in withdrawReward() function
// 2. Added a check to ensure that the recipient has rewards to withdraw before calling withdrawReward()
// 3. Moved claimedBonus[recipient] = true; statement before the call to withdrawReward() to prevent reentrancy vulnerability. 
// 4. Passed msg.sender instead of recipient to withdrawReward() function in getFirstWithdrawalBonus() function to prevent reentrancy vulnerability.