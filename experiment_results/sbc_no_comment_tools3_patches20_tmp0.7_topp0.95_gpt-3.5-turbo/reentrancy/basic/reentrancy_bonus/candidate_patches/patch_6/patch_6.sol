pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address recipient) public {
        require(rewardsForA[recipient] > 0); // Check if there are rewards to withdraw
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        require(msg.sender.call.value(amountToWithdraw)()); // Use msg.sender instead of recipient to prevent reentrancy
    }

    function getFirstWithdrawalBonus() public {
        require(!claimedBonus[msg.sender]); // Check if bonus has not been claimed before

        rewardsForA[msg.sender] += 100;

        claimedBonus[msg.sender] = true;
        withdrawReward(msg.sender); // Withdraw the bonus after it has been claimed
    }
}