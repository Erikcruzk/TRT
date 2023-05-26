pragma solidity ^0.4.0;

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = SafeMath.add(now, 1 weeks);
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] = SafeMath.add(lockTime[msg.sender], _secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        require(now > lockTime[msg.sender]);
        uint transferValue = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
}