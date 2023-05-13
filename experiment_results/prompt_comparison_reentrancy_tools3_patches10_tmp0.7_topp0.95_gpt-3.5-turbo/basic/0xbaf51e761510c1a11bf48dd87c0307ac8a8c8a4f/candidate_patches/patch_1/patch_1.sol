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
        if (!msg.sender.send(_am)) {
            balances[msg.sender] += _am;
            revert();
        }
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

//Changes made:
//1. Function names have been changed to follow Solidity naming conventions.
//2. In function cashOut, the external call to msg.sender.send has been replaced with a conditional statement to handle if the call fails.
//3. In function cashOut, a require statement has been added to check if the user has sufficient balance to withdraw.
//4. In function addMessage, a new Message struct is created in memory for each message to prevent overwriting the previous message.