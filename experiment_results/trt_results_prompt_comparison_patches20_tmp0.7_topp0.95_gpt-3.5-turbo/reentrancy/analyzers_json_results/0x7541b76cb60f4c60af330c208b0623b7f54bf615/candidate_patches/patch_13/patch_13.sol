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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Moved the mapping and MinSum variables to the top of the contract for better readability
// 2. Changed the var keyword to storage in the Collect function
// 3. Added a require statement to check if the balance is greater than or equal to the minimum sum and unlock time has passed
// 4. Replaced the external call with a transfer to prevent reentrancy attacks
// 5. Created a new message struct variable in the Log contract to avoid overwriting the previous message when adding to the history array
// 6. Changed the visibility of the Collect and Put functions to public for better accessibility.