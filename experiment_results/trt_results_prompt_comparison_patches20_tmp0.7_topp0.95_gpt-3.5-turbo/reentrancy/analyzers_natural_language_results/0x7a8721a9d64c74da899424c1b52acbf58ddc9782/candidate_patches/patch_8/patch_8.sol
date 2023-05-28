pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner); // changed from tx.origin to msg.sender
        _;
    }

    constructor() public { // added constructor keyword
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner { // added public visibility keyword
        TransferLog = Log(_lib);
    }

    function deposit() public payable { // changed function name to lowercase and added public visibility keyword
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // changed function name to lowercase
        }
    }

    function cashOut(uint _am) public { // changed function name to lowercase and added public visibility keyword
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if (msg.sender.call.value(_am)()) {
                TransferLog.addMessage(msg.sender, _am, "CashOut"); // changed function name to lowercase
            }
        }
    }

    function() public payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    Message LastMsg;

    function addMessage(address _adr, uint _val, string _data) public { // changed function name to lowercase and added public visibility keyword
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}