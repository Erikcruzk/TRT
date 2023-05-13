pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping(address => Holder) public Acc;
    
    Log LogFile;
    
    uint public MinSum = 2 ether;
    
    function U_BANK(address log) public {
        LogFile = Log(log);
    }
    
    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }
    
    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
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
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = now;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }
} 

// Changes Made:
// 1. Added the Holder struct and mapping to store the account information of the users.
// 2. Removed the 'payable' modifier from the Collect function as it doesn't require any payment.
// 3. Added 'require' statement to check if the user has sufficient balance, minimum sum requirement and unlock time has passed before allowing to withdraw.
// 4. Replaced 'call.value' with 'transfer' to prevent reentrancy attack.
// 5. Removed the 'var' keyword and used 'storage' to define the 'acc' variable in functions.
// 6. Changed the 'LogFile.AddMessage' function call in the 'AddMessage' function to use a memory variable instead of a storage variable.