pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum = 1 ether;

    Log LogFile;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = (_unlockTime > now) ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Moved the struct 'Holder' above the mapping 'Acc' as it is a good practice to declare the struct before using it in the mapping.
// 2. Added a constructor to initialize the 'LogFile' contract address.
// 3. Changed the function 'Collect' to a non-payable function as it is not necessary to send ether along with the function call.
// 4. Replaced the 'if' statement in 'Collect' with a 'require' statement for better readability and security.
// 5. Moved the 'acc.balance -= _am' and 'LogFile.AddMessage' statements before the 'msg.sender.transfer(_am)' statement in the 'Collect' function as it is a good practice to transfer funds at the end of the function execution.
// 6. Added a memory keyword while creating a new 'lastMsg' struct in the 'AddMessage' function of the 'Log' contract to prevent it from being stored in storage.