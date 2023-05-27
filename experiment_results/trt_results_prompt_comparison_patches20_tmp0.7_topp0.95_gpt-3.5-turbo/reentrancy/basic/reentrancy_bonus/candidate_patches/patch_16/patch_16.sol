pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check if recipient has any reward to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // Use msg.sender instead of recipient to prevent re-entrancy
    }

    function getFirstWithdrawalBonus() public {
        require(!claimedBonus[msg.sender]); // Check if the caller has already claimed the bonus
        rewardsForA[msg.sender] += 100;
        claimedBonus[msg.sender] = true;
        withdrawReward(msg.sender);
    }
}