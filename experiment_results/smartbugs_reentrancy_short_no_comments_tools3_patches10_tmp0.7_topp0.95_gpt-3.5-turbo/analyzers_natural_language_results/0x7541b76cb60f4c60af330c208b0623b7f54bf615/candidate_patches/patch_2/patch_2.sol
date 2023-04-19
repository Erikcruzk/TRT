pragma solidity ^0.8.0;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log private LogFile;

    uint public MinSum = 2 ether;    

    constructor(address log) {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance is less than minimum sum");
        require(acc.balance >= _am, "Amount is greater than balance");
        require(block.timestamp > acc.unlockTime, "Account is locked");
        acc.balance -= _am;
        payable(msg.sender).transfer(_am);
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

    Message[] private History;

    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory msg;
        msg.Sender = _adr;
        msg.Time = block.timestamp;
        msg.Val = _val;
        msg.Data = _data;
        History.push(msg);
    }

    function getHistoryLength() public view returns(uint) {
        return History.length;
    }

    function getMessage(uint index) public view returns(Message memory) {
        require(index < History.length, "Index out of bounds");
        return History[index];
    }
} 

// Changes Made:
// 1. Replaced var with explicit types for variables.
// 2. Used block.timestamp instead of now.
// 3. Added error messages for require statements.
// 4. Made Collect function non-payable and used transfer instead.
// 5. Renamed LastMsg to msg in Log contract to avoid confusion with msg keyword.
// 6. Added getter functions to Log contract for retrieving message history.