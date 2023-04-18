pragma solidity ^0.8.0;

contract X_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;    

    constructor(address log) {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime) {
            acc.balance -= _am;
            (bool success, ) = msg.sender.call{value: _am}("");
            if (success) {
                LogFile.AddMessage(msg.sender, _am, "Collect");
            } else {
                acc.balance += _am;
            }
        }
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

    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = block.timestamp;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes made:
// 1. Added constructor to initialize LogFile
// 2. Changed var to storage in Put and Collect functions
// 3. Changed now to block.timestamp
// 4. Added check for success in Collect function and reverted balance if call was unsuccessful
// 5. Added memory keyword to string parameter in AddMessage function
// 6. Added memory keyword to Message variable in AddMessage function to avoid storage pointer error.