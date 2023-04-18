pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
    uint public minDeposit = 1 ether;
    Log transferLog;

    function PrivateBank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        if(msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
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
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMessage);
    }
}

// Changes made:
// 1. Changed the contract and function names to start with capital letters (convention)
// 2. Changed 'MinDeposit' to 'minDeposit' to follow naming conventions
// 3. Added 'public' visibility to the constructor
// 4. Added 'require' statement to check for sufficient balance in 'cashOut' function
// 5. Changed 'call.value' to 'transfer' in 'cashOut' function to prevent reentrancy vulnerability
// 6. Changed 'LastMsg' to 'lastMsg' to follow naming conventions
// 7. Added 'memory' keyword to 'Message' struct in 'addMessage' function to prevent stack too deep error
// 8. Added 'now' keyword to 'time' field in 'Message' struct to get current timestamp.