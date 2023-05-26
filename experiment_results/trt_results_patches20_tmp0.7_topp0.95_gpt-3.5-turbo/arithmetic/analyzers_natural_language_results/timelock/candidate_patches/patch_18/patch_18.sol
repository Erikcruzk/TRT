pragma solidity ^0.8.0;

contract TimeLock {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint256 _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient balance");
        require(block.timestamp > lockTime[msg.sender], "Funds are locked");
        uint256 transferValue = balances[msg.sender];
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(transferValue);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Changed uint to uint256 for mapping values to avoid potential integer overflow/underflow.
// 3. Replaced now with block.timestamp for getting the current timestamp.
// 4. Added error messages in require statements for better clarity.
// 5. Replaced transfer() with payable(msg.sender).transfer() to follow best practices.