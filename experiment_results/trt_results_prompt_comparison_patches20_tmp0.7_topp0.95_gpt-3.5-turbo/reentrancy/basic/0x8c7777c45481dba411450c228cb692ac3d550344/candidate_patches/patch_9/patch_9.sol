pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log public TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am > 0 && _am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.send(_am));
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
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed the function names to follow Solidity naming conventions.
// 2. Added 'require' statements to check for conditions before executing.
// 3. Changed the function 'cashOut' to use 'send' instead of 'call'.
// 4. Renamed the Log function 'AddMessage' to 'addMessage' to follow Solidity naming conventions.
// 5. Modified the 'addMessage' function to create a new Message struct for each message added to the history array.