pragma solidity ^0.4.25;

contract X_WALLET {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;

    event LogDeposit(address indexed sender, uint value, uint unlockTime);
    event LogWithdrawal(address indexed sender, uint value);

    uint public minSum = 1 ether;

    function deposit(uint _unlockTime) public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = (_unlockTime > now) ? _unlockTime : now;
        emit LogDeposit(msg.sender, msg.value, unlockTimes[msg.sender]);
    }

    function withdraw(uint _am) public {
        require(balances[msg.sender] >= _am && _am > 0 && now >= unlockTimes[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        emit LogWithdrawal(msg.sender, _am);
    }

    function() public payable {
        deposit(0);
    }
}