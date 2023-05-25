pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        }
        else {
            balances[msg.sender] += _am;
        }
    }

    function() public payable {}
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
        Message memory LastMsg = Message(_adr, _data, _val, now);
        History.push(LastMsg);
    }
}