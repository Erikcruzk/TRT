pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit); // changed if statement to require
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // changed function name to lowercase
    }

    function cashOut(uint _am) public {
        require(_am > 0 && _am <= balances[msg.sender]); // added a check to make sure _am is valid
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)()); // added require to check if the transfer was successful
        TransferLog.addMessage(msg.sender, _am, "CashOut"); // changed function name to lowercase
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