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

    function cashOut(uint _amount) public {
        if (_amount <= balances[msg.sender]) {
            if (msg.sender.call.value(_amount)()) {
                balances[msg.sender] -= _amount;
                transferLog.addMessage(msg.sender, _amount, "CashOut");
            }
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint value;
        uint time;
    }

    Message[] public history;

    function addMessage(address _address, uint _value, string _data) public {
        Message memory newMessage;
        newMessage.sender = _address;
        newMessage.time = now;
        newMessage.value = _value;
        newMessage.data = _data;
        history.push(newMessage);
    }
}