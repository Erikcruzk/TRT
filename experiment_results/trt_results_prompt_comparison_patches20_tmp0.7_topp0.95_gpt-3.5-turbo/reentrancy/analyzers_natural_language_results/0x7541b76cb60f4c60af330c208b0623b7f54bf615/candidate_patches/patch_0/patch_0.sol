pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;

    event LogDeposit(address indexed sender, uint amount);
    event LogWithdrawal(address indexed sender, uint amount);

    uint public minSum = 2 ether;

    function deposit(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am && now > unlockTimes[msg.sender], "Insufficient balance or unlock time not reached");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        emit LogWithdrawal(msg.sender, _am);
    }

    function() public payable {
        deposit(0);
    }
}