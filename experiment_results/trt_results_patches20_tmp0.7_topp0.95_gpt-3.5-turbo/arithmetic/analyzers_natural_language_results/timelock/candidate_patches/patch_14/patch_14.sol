pragma solidity ^0.4.0;

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() public payable {
        require(msg.value + balances[msg.sender] >= balances[msg.sender]); // fix arithmetic overflow vulnerability
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = now + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        require(lockTime[msg.sender] + _secondsToIncrease >= lockTime[msg.sender]); // fix arithmetic overflow vulnerability
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        require(now > lockTime[msg.sender]);
        uint transferValue = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
}