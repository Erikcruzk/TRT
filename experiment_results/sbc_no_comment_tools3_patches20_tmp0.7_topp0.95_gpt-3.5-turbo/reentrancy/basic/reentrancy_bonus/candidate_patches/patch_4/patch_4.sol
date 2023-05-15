pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // check if reward is available
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // use msg.sender to prevent reentrancy
    }

    function getFirstWithdrawalBonus() public {
        require(!claimedBonus[msg.sender]); // use msg.sender instead of recipient

        rewardsForA[msg.sender] += 100;

        withdrawReward(msg.sender); // use msg.sender instead of recipient
        claimedBonus[msg.sender] = true;
    }
}