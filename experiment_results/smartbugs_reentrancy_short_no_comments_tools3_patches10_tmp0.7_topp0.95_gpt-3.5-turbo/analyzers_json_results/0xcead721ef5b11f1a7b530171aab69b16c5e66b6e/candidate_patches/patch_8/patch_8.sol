pragma solidity ^0.4.25;

contract WALLET {
    
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    
    Log LogFile;
    
    uint public MinSum = 1 ether;    
    
    function WALLET(address log) public{
        LogFile = Log(log);
    }
    
    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
    }

    function() public payable {
        Put(0);
    }

}

contract Log {
    
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
    
}