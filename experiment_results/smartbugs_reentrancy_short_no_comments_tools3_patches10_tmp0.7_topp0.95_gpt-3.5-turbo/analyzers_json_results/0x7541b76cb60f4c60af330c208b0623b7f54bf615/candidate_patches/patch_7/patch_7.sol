pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {   
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 2 ether;    

    function U_BANK(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than zero");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Insufficient balance");
        require(acc.balance >= _am, "Requested amount is greater than the balance");
        require(now > acc.unlockTime, "Funds are locked");
        acc.balance -= _am;
        require(msg.sender.call.value(_am)(), "Transfer failed");
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
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
    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The repaired contract includes the following changes: 
// 1. Added require statements to validate input parameters and conditions
// 2. Changed the var keyword to explicit storage variable types 
// 3. Moved the Log contract to the end to avoid compilation errors.