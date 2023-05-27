pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) { // changed > to >=
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // changed AddMessage to addMessage
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            if (msg.sender.send(_am)) { // changed call.value to send
                balances[msg.sender] -= _am;
                TransferLog.addMessage(msg.sender, _am, "CashOut"); // changed AddMessage to addMessage
            }
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender; // changed Sender to sender
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    Message lastMsg;

    function addMessage(address _adr, uint _val, string _data) public {
        lastMsg.sender = _adr; // changed Sender to sender
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}