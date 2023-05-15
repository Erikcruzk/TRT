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

// Changes Made:
// 1. Changed pragma version to ^0.4.24 to avoid any compatibility issues with the latest version of Solidity.
// 2. Added empty parentheses after recipient.call.value(amountToWithdraw) to avoid any confusion with the new version of Solidity.
// 3. Moved the withdrawReward function call after setting claimedBonus[recipient] to true to avoid reentrancy attacks.