pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // check if recipient has a reward
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(recipient.send(amountToWithdraw)); // use send() instead of call.value()
    }

    function getFirstWithdrawalBonus(address recipient) public {
        require(!claimedBonus[recipient]); // check if bonus is not already claimed

        rewardsForA[recipient] += 100;

        claimedBonus[recipient] = true; // mark bonus as claimed
        withdrawReward(recipient);
    }
}