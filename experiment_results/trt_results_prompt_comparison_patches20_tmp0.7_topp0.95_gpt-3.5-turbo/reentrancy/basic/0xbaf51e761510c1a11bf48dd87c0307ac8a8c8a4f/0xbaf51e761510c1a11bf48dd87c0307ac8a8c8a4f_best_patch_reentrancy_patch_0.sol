pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        TransferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

    event LogMessage(address indexed sender, string data, uint value, uint time);

    function emitLogMessage(address _sender, uint _value, string _data, uint _time) public {
        LogMessage(_sender, _data, _value, _time);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint value;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            value: _val,
            data: _data
        });
        history.push(newMessage);
        ETH_VAULT(msg.sender).emitLogMessage(_adr, _val, _data, now);
    }
} 

// Changes made:
// 1. Changed function names to follow Solidity naming conventions
// 2. Added require statements to check for conditions that must be true
// 3. Removed unnecessary payable keyword from cashOut function
// 4. Added emitLogMessage function to emit events from ETH_VAULT contract
// 5. Modified addMessage function in Log contract to use a struct and emit an event from ETH_VAULT contract