pragma solidity ^0.4.24;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward() public {
        uint amountToWithdraw = rewardsForA[msg.sender];
        rewardsForA[msg.sender] = 0;
        require(msg.sender.call.value(amountToWithdraw)());
    }

    function getFirstWithdrawalBonus() public {
        require(!claimedBonus[msg.sender]);

        rewardsForA[msg.sender] += 100;

        claimedBonus[msg.sender] = true;
        withdrawReward();
    }
}