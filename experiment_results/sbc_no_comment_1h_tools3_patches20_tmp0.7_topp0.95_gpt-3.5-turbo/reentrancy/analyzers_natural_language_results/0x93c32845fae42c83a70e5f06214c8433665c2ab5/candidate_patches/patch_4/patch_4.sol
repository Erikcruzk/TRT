pragma solidity ^0.4.25;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isHolder;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function X_WALLET(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(Acc[msg.sender].isHolder == true, "You need to be a holder.");
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(Acc[msg.sender].isHolder == true, "You need to be a holder.");
        require(Acc[msg.sender].balance >= MinSum, "Balance must be greater than minimum sum.");
        require(Acc[msg.sender].balance >= _am, "Requested amount is greater than balance.");
        require(now > Acc[msg.sender].unlockTime, "Unlock time not reached yet.");
        Acc[msg.sender].balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function addHolder() public {
        require(Acc[msg.sender].isHolder == false, "You are already a holder.");
        Acc[msg.sender].isHolder = true;
    }

    function removeHolder() public {
        require(Acc[msg.sender].isHolder == true, "You are not a holder.");
        require(Acc[msg.sender].balance == 0, "Balance must be 0 to remove holder.");
        Acc[msg.sender].isHolder = false;
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