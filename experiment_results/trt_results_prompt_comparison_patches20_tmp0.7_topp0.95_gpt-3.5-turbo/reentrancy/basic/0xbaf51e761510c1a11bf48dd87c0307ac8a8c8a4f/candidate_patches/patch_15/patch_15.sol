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
        msg.sender.transfer(_am);
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
    Message lastMsg;

    function addMessage(address _adr, uint _val, string _data) public {
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

//Changes Made
//1. Function names have been changed to follow the convention of starting with a lowercase letter
//2. Made the "cashOut" function safer by adding a "require" statement to check if the sender has enough balance
//3. Changed the "call.value" to "transfer" as it is safer and recommended by Solidity documentation
//4. Changed the struct variable names to start with a lowercase letter to follow convention
//5. Changed the function parameter name "am" to "_am" for consistency