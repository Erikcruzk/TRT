pragma solidity ^0.8.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(payable(recipient).send(amountToWithdraw));
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]);

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true;
        withdrawReward(recipient);
    }
}

// The vulnerable code has been fixed by using the "send" method instead of "call.value" to transfer funds and by moving the state variable update before the external function call to prevent reentrancy attacks. Additionally, the code has been updated to Solidity version 0.8.0 to ensure compatibility with the latest version of the language.