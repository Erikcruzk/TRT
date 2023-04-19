pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;

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
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes Made:
// 1. Renamed MinDeposit to minDeposit and made it lower camel case.
// 2. Added public visibility to functions.
// 3. Replaced if statement with require statement.
// 4. Moved balances[msg.sender] -= _am and transferLog.addMessage(msg.sender, _am, "CashOut") statements before the transfer statement to prevent re-entrancy attack.
// 5. Removed LastMsg variable and used the push() function directly in addMessage() function.