pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;    
    
    constructor(address log) public {
        LogFile = Log(log);
    }
    
    function put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }
    
    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }
    
    function() public payable {
        put(0);
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
    Message LastMsg;
    
    function addMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// The repaired contract has:
// - Added explicit visibility modifiers to functions
// - Changed the constructor name to `constructor`
// - Changed `var` to `Holder storage` to explicitly state storage location
// - Changed `msg.sender.call.value(_am)()` to `msg.sender.transfer(_am)` to avoid reentrancy vulnerability
// - Added a `require` statement to `collect` function to check conditions before executing the transaction
// - Changed `LogFile` to `Log` to match the contract name
// - Changed `LogFile.AddMessage` to `LogFile.addMessage` to match the function name