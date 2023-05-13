pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    function PrivateBank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            transferLog.addMessage(msg.sender, _am, "CashOut");
            msg.sender.transfer(_am);
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}