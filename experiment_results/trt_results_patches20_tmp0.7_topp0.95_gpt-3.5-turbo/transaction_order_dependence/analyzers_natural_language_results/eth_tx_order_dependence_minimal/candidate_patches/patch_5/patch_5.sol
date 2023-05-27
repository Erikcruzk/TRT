pragma solidity ^0.4.16;

contract EthTxOrderDependenceMinimal {
    address public owner;
    bool public claimed;
    uint public reward;

    constructor() public {
        owner = msg.sender;
    }

    function setReward() public payable {
        require(!claimed);
        require(msg.sender == owner);

        reward = msg.value;
        owner.transfer(reward);
    }

    function claimReward(uint256 submission) public {
        require(!claimed);
        require(submission < 10);

        claimed = true;
        msg.sender.transfer(reward);
    }
}