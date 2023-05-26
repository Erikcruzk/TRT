pragma solidity ^0.4.25;

contract X_WALLET {
    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        if (
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ) {
            acc.balance -= _am;
            if (msg.sender.call.value(_am)()) {
                LogFile.AddMessage(msg.sender, _am, "Collect");
            } else {
                acc.balance += _am;
            }
        }
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

    constructor(address log) public {
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made: 
// 1. Added 'storage' keyword to 'acc' variable in both Put and Collect functions
// 2. Moved the balance subtraction operation before the external call in Collect function
// 3. Added else statement to add back the balance in case of failed external call in Collect function
// 4. Changed constructor name to 'constructor' as per the latest Solidity version
// 5. Changed 'LastMsg' variable to 'newMessage' in Log contract and made it a memory variable
// 6. Removed 'LastMsg' variable assignment from AddMessage function in Log contract to prevent overwriting the previous message.