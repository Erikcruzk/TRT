pragma solidity ^0.4.0;

contract TimeLock {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = SafeMath.add(now, 1 weeks);
    }

    function increaseLockTime(uint256 _secondsToIncrease) public {
        require(_secondsToIncrease > 0);
        lockTime[msg.sender] = SafeMath.add(lockTime[msg.sender], _secondsToIncrease);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        require(now > lockTime[msg.sender]);
        uint256 transferValue = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }
}