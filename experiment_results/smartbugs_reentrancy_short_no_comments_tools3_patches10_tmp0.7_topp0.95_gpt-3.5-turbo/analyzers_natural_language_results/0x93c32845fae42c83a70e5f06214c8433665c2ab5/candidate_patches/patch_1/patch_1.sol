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

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Invalid transaction");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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
// 1. Updated pragma version to ^0.8.0.
// 2. Added constructor function instead of using function name as contract name.
// 3. Changed the keyword 'var' to 'storage' to explicitly define the storage location of a variable.
// 4. Added require statements to check for valid transactions.
// 5. Changed now to block.timestamp for better security.
// 6. Added visibility specifier 'external' to fallback function.
// 7. Removed unnecessary payable specifier from Collect function.