pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
        bool isHolder;
    }

    modifier onlyHolder {
        require(Acc[msg.sender].isHolder == true);
        _;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        Acc[msg.sender].isHolder = true;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public onlyHolder {
        require(Acc[msg.sender].balance >= MinSum);
        require(Acc[msg.sender].balance >= _am);
        require(now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}