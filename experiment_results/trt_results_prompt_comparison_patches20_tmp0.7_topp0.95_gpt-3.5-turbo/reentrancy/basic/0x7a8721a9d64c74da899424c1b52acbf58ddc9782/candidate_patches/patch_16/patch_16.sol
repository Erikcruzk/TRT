pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner); // changed tx.origin to msg.sender for better security
        _;
    }

    constructor() public { // changed function name to constructor
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner { // added public visibility modifier
        TransferLog = Log(_lib);
    }

    function deposit() public payable { // changed function name to lowercase
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // changed function name to lowercase
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            require(msg.sender.call.value(_am)()); // added require statement for better security
            balances[msg.sender] -= _am;
            TransferLog.addMessage(msg.sender, _am, "CashOut"); // changed function name to lowercase
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

    Message lastMsg; // changed variable name to lowercase

    function addMessage(address _adr, uint _val, string _data) public { // changed function name to lowercase
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg); // changed variable name to lowercase
    }
}