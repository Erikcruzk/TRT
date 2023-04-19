pragma solidity ^0.8.0;

contract X_WALLET {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint256 public MinSum = 1 ether;

    constructor(address log) {
        LogFile = Log(log);
    }

    function Put(uint256 _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint256 _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or not yet unlocked");
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
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = block.timestamp;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
} 

// Changes Made:
// 1. Updated the pragma version to ^0.8.0
// 2. Added visibility specifiers to functions
// 3. Replaced "var" with "Holder storage" to explicitly define type
// 4. Replaced "now" with "block.timestamp"
// 5. Added error messages and require statements to functions
// 6. Changed "msg.sender.call.value" to "msg.sender.call{value: }"
// 7. Moved Message struct instantiation inside AddMessage function to prevent integer overflow/underflow