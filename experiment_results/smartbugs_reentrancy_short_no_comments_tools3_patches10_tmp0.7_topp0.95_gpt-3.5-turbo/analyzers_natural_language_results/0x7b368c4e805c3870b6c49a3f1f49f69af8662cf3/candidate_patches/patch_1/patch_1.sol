pragma solidity ^0.8.0;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping (address => Holder) public Acc;
    uint public MinSum = 1 ether;
    Log LogFile;

    constructor(address log) {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or unlock time not reached");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Failed to transfer funds");
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
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
    Message LastMsg;

    function AddMessage(address _adr, uint _val, string memory _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Updated Solidity version to ^0.8.0
// 2. Added visibility modifiers to functions
// 3. Updated now to block.timestamp for improved security
// 4. Added require statements to ensure valid inputs and prevent errors
// 5. Changed var to explicit Holder storage for better readability
// 6. Added error handling for failed transfers
// 7. Moved struct Holder and mapping Acc above the functions for readability
// 8. Renamed function() to function() external payable for clarity and to adhere to best practices.