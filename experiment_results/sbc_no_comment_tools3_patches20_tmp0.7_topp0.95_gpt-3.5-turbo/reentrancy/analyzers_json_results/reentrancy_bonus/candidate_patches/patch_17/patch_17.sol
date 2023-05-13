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
        claimedBonus[recipient] = true;
        rewardsForA[recipient] += 100;
        withdrawReward(recipient);
    }
} 

// The issue of reentrancy has been fixed by changing the order of operations in the getFirstWithdrawalBonus function. The claimedBonus state variable is now set before calling the withdrawReward function to prevent any reentrancy attacks. Additionally, the contract version has been updated to a more recent version of Solidity.