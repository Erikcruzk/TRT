pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log private LogFile;
    uint public MinSum = 2 ether;

    event Deposit(address indexed account, uint amount);
    event Withdrawal(address indexed account, uint amount);

    function U_BANK(address log) public {
        LogFile = Log(log);
    }

    function deposit(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than 0");
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _am) public {
        require(_am > 0, "Amount should be greater than 0");
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than minimum sum");
        require(acc.balance >= _am, "Amount should be less than or equal to balance");
        require(now > acc.unlockTime, "Unlock time has not passed yet");
        acc.balance -= _am;
        emit Withdrawal(msg.sender, _am);
        require(msg.sender.call.value(_am)(), "Transfer failed");
    }

    function() public payable {
        deposit(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        History.push(Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        }));
    }
}