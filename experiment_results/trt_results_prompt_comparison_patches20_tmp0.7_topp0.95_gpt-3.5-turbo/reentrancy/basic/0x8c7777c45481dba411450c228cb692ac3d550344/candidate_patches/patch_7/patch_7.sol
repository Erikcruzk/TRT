pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log public TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        if (!msg.sender.send(_am)) {
            balances[msg.sender] += _am;
        } else {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

//Changes Made:
//1. Added public visibility to Log instance in line 6.
//2. Changed > to >= in line 11 to handle the case of msg.value being equal to MinDeposit.
//3. Added a require statement in line 16 to check if the user has enough balance to cash out.
//4. Replaced msg.sender.call.value with msg.sender.send in line 18 to avoid potential re-entrancy attack.
//5. Added an else statement in line 20 to add the message to the log only if the transfer was successful.
//6. Added a memory keyword to LastMsg in line 30 to avoid overwriting the previous message in the History array.