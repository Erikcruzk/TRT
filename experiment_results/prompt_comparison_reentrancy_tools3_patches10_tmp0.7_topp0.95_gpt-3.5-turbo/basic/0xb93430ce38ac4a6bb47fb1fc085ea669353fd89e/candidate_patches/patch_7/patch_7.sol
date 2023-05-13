pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    constructor(address _lib) public {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            if (msg.sender.send(_am)) {
                balances[msg.sender] -= _am;
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
    }

    function() public payable {}

    function getHistoryLength() public view returns (uint) {
        return TransferLog.History.length;
    }

    function getLastMessage() public view returns (address, string, uint, uint) {
        Log.Message memory lastMsg = TransferLog.LastMsg();
        return (lastMsg.Sender, lastMsg.Data, lastMsg.Val, lastMsg.Time);
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

    Message public LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }

    function getLastMessage() public view returns (address, string, uint, uint) {
        Message memory lastMsg = LastMsg;
        return (lastMsg.Sender, lastMsg.Data, lastMsg.Val, lastMsg.Time);
    }
}