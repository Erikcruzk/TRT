pragma solidity ^0.4.25;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    event Deposit(address indexed depositor, uint value);
    event Withdrawal(address indexed withdrawer, uint value);

    function W_WALLET(address log) public{
        LogFile = Log(log);
    }

    function deposit(uint _unlockTime) public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0.");
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _am) public {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Account balance must be greater than or equal to minimum sum.");
        require(acc.balance >= _am, "Requested withdrawal amount must be less than or equal to account balance.");
        require(now > acc.unlockTime, "Funds are locked and cannot be withdrawn yet.");
        acc.balance -= _am;
        emit Withdrawal(msg.sender, _am);
        require(msg.sender.call.value(_am)(), "Error: withdrawal failed.");
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
        Message memory newMsg = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        History.push(newMsg);
    }
}