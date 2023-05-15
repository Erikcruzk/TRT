pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)(), "Transfer failed");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

    // Added function to get balance of an address
    function getBalance(address _adr) public view returns (uint) {
        return balances[_adr];
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = now;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
}