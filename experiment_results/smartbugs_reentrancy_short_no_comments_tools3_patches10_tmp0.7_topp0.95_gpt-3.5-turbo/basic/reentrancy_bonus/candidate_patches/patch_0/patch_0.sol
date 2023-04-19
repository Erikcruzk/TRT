pragma solidity ^0.8.0;

contract Reentrancy_bonus{

    mapping (address => uint) private userBalances;
    mapping (address => bool) private claimedBonus;
    mapping (address => uint) private rewardsForA;

    function withdrawReward(address payable recipient) public {
        require(msg.sender == address(this), "Unauthorized access");
        uint amountToWithdraw = rewardsForA[recipient];
        rewardsForA[recipient] = 0;
        (bool success, ) = recipient.call{value: amountToWithdraw}("");
        require(success);
    }

    function getFirstWithdrawalBonus() public {
        require(!claimedBonus[msg.sender], "Bonus already claimed"); 
        claimedBonus[msg.sender] = true;
        rewardsForA[msg.sender] += 100;
        withdrawReward(payable(msg.sender));
    }
}