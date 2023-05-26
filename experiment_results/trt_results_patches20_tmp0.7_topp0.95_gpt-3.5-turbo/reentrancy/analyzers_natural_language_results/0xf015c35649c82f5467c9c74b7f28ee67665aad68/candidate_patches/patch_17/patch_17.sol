pragma solidity ^0.4.25;

contract MY_BANK {
    bool private locked;
    mapping(address => uint) public balances;
    uint public minSum = 1 ether;

    Log logFile;

    event LogDeposit(address sender, uint value);
    event LogWithdrawal(address receiver, uint value);

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        logFile.addMessage(msg.sender, msg.value, "Deposit");
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint _am) public payable noReentrancy {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        require(now > logFile.getUnlockTime(msg.sender));

        balances[msg.sender] -= _am;
        require(msg.sender.send(_am));

        logFile.addMessage(msg.sender, _am, "Withdrawal");
        emit LogWithdrawal(msg.sender, _am);
    }

    function() public payable {
        deposit();
    }

    function setLogFile(address log) public {
        logFile = Log(log);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
        uint unlockTime;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.val = _val;
        newMessage.data = _data;
        newMessage.time = now;
        newMessage.unlockTime = now + 1 days;

        history.push(newMessage);
    }

    function getUnlockTime(address _adr) public view returns (uint) {
        for (uint i = 0; i < history.length; i++) {
            if (history[i].sender == _adr) {
                return history[i].unlockTime;
            }
        }
        return 0;
    }
}