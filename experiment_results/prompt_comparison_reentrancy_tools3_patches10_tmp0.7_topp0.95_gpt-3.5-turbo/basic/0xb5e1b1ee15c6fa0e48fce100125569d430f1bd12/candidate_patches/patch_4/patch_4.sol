pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit); // Use require to check condition
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // Function names should start with lowercase
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // Use require to check condition
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)()); // Use require to check condition
        TransferLog.addMessage(msg.sender, _am, "CashOut"); // Function names should start with lowercase
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