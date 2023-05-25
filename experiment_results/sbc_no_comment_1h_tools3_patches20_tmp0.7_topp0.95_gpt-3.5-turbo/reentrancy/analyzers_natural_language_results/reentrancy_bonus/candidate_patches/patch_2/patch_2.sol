pragma solidity ^0.4.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;
    bool private locked;

    function withdrawReward(address recipient) public {
        require(!locked);
        locked = true;
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success);
        locked = false;
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
}

// In the repaired contract, a locking mechanism has been implemented to prevent reentrancy attacks. The 'locked' variable is set to true before the external call is made and reset to false after the call is completed. This ensures that the function cannot be called again until the previous call has been completed. Additionally, the 'claimedBonus' boolean is set to true before the reward is added to prevent multiple calls for the same recipient.