pragma solidity ^0.8.0;

contract TimeLock {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint256 _secondsToIncrease) public {
        require(_secondsToIncrease > 0, "Seconds to increase should be greater than zero");
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "No balance to withdraw");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired yet");
        uint256 transferValue = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(transferValue);
    }
}