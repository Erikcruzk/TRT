pragma solidity ^0.4.25;

contract WALLET {
    bool private locked;
    function Put(uint _unlockTime) public payable {
        require(!locked);
        locked = true;
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
        locked = false;
    }

    function Collect(uint _am) public payable {
        require(!locked);
        locked = true;
        var acc = Acc[msg.sender];
        if (
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ) {
            acc.balance -= _am;
            if (msg.sender.call.value(_am)()) {
                LogFile.AddMessage(msg.sender, _am, "Collect");
            }
        }
        locked = false;
    }

    function() public payable {
        Put(0);
    }

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function WALLET(address log) public {
        LogFile = Log(log);
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

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// The repaired smart contract includes a reentrancy guard by using a `locked` boolean variable to prevent multiple calls to the same function before the first call has completed. Additionally, the order of the state changes has been rearranged to prevent reentrancy attacks. Finally, the `LogFile.AddMessage` function call has been moved to after the state changes to prevent SWC-107 vulnerabilities.