pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
        bool isExist;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function MY_BANK(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        require(msg.value > 0, "Amount should be greater than zero");
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        if(!acc.isExist){
            acc.isExist = true;
        }
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.isExist, "Account does not exist");
        require(acc.balance >= MinSum, "Minimum balance is not maintained");
        require(acc.balance >= _am, "Insufficient balance");
        require(now > acc.unlockTime, "Funds are locked");
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes made:
// 1. Added a boolean flag 'isExist' in the Holder struct to check if an account exists or not.
// 2. Added require statements to handle errors and prevent reentrancy.
// 3. Changed the Collect function to use transfer instead of call.value to prevent reentrancy.
// 4. Removed the 'var' keyword and replaced it with 'storage' or 'memory' depending on the context.
// 5. Moved the declaration of 'LastMsg' inside the AddMessage function to prevent overwriting of the last message.