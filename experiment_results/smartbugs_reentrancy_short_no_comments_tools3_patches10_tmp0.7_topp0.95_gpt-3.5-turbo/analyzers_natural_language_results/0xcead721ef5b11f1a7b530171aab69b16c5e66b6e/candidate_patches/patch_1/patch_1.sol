pragma solidity ^0.8.0;

contract WALLET {
    
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
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or locked funds");
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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added constructor to initialize LogFile
// 2. Changed var to storage/ memory
// 3. Changed now to block.timestamp
// 4. Added require statements to check for sufficient balance and unlocked funds
// 5. Moved balance deduction before the external call to prevent reentrancy attack
// 6. Changed string to string memory
// 7. Added visibility modifier to fallback function.