pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint256) public balances;
    uint256 public minDeposit = 1 ether;
    Log TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint256 _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.addMessage(msg.sender, _am, "CashOut");
            require(msg.sender.call.value(_am)());
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    Message[] public history;

    function addMessage(address _adr, uint256 _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}