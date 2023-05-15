pragma solidity ^0.5.0;

contract Reentrancy_bonus {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private claimedBonus;
    mapping(address => uint) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call.value(amountToWithdraw)("");
        require(success, "Withdrawal failed");
    }

    function getFirstWithdrawalBonus() public {
        require(!claimedBonus[msg.sender], "Bonus already claimed");

        rewardsForA[msg.sender] += 100;

        withdrawReward(msg.sender);
        claimedBonus[msg.sender] = true;
    }
}