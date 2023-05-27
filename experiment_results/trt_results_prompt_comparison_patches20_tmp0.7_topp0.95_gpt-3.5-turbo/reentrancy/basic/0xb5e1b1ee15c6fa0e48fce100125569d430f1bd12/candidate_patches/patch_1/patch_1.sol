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
        require(_amount > 0 && _amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        transferLog.addMessage(msg.sender, _amount, "CashOut");
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

    function addMessage(address _address, uint _value, string _data) public {
        Message memory newMessage = Message({
            sender: _address,
            time: now,
            val: _value,
            data: _data
        });
        history.push(newMessage);
    }
}