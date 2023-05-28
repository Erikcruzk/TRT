pragma solidity ^0.4.16;

contract EthTxOrderDependenceMinimal {
    address public owner;
    bool public claimed;
    uint public reward;

    function EthTxOrderDependenceMinimal() public {
        owner = msg.sender;
    }

    function setReward() public payable {
        require(!claimed);
        reward = msg.value;
    }

    function claimReward(uint256 submission) public {
        require(!claimed);
        require(submission < 10);
        claimed = true;
        msg.sender.transfer(reward);
    }
}