pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => uint) balances;
    mapping(address => uint) unlockTimes;

    event LogDeposit(address indexed sender, uint amount);
    event LogWithdrawal(address indexed sender, uint amount);

    uint public minSum = 1 ether;

    function deposit(uint _unlockTime) public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint _am) public {
        require(balances[msg.sender] >= minSum);
        require(balances[msg.sender] >= _am);
        require(now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        emit LogWithdrawal(msg.sender, _am);
    }

    function() public payable {
        deposit(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
}