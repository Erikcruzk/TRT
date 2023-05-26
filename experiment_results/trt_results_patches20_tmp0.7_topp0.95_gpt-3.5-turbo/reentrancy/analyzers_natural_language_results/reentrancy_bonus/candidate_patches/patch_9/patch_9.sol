pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(recipient.call.value(amountToWithdraw)());
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;
        claimedBonus[recipient] = true;

        withdrawReward(recipient);
    }
}

// The contract has been repaired by moving the claimedBonus state variable update before the external call to withdrawReward function. This ensures that no state modifications are executed after the external call and there are no reentrancy vulnerabilities. Additionally, the call to withdrawReward function has been updated to use the "require" statement instead of the boolean variable "success" to ensure that the function execution fails if the external call fails.