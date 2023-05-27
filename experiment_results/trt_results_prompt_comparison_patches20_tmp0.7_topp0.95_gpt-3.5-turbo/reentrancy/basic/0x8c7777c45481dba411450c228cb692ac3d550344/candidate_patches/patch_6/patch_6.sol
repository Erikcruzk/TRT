pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public minDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
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
        Message memory newMsg;
        newMsg.sender = _adr;
        newMsg.time = now;
        newMsg.val = _val;
        newMsg.data = _data;
        history.push(newMsg);
    }
} 

// Changes made:
// 1. Renamed MinDeposit variable to minDeposit to follow Solidity naming conventions.
// 2. Added require statement in deposit() function to check if msg.value is greater than or equal to minDeposit.
// 3. Changed CashOut() function to remove the unnecessary if statement and use require() instead.
// 4. Changed msg.sender.call.value() to msg.sender.send() in CashOut() function as it is a safer way to transfer ether.
// 5. Renamed AddMessage() function to addMessage() to follow Solidity naming conventions.
// 6. Changed LastMsg struct to a memory variable and created a new Message struct in addMessage() function to avoid overwriting the last message.