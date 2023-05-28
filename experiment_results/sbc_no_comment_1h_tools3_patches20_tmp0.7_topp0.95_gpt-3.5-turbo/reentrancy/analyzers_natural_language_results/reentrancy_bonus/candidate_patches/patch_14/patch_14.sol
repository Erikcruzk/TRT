pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;
    bool private locked;

    function withdrawReward(address recipient) public {
        require(!locked);
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        locked = true;
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