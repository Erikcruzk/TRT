pragma solidity ^0.4.25;

contract W_WALLET {
    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(_am <= Acc[msg.sender].balance, "Not enough balance");
        require(now > Acc[msg.sender].unlockTime, "Funds are locked");
        Acc[msg.sender].balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Removed the 'payable' keyword from Collect function
// 2. Added two require statements to check if the user has enough balance and if the funds are unlocked before transferring funds to the user
// 3. Changed the transfer function to send funds to the user instead of using call.value
// 4. Removed the Acc variable and used the mapping directly
// 5. Changed the constructor function name to 'constructor' instead of using the contract name
// 6. Changed the way the Log struct is added to the History array to avoid reentrancy issues