pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => Holder) public Acc;
    uint public MinSum = 2 ether;
    Log LogFile;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    function U_BANK(address log) public {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
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
        Message memory msg = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        History.push(msg);
    }
} 

// Changes made:
// 1. Moved the mapping and struct to the top and added the storage keyword to the acc variable in the Collect function.
// 2. Replaced the external call with a transfer function to avoid reentrancy vulnerability.
// 3. Used require statements to ensure the conditions are met before the function is executed.
// 4. Removed the var keyword and used explicit type declarations for variables.
// 5. Changed the LastMsg variable in the Log contract to a memory variable to prevent overwriting of previous messages.