pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log private transferLog;
    
    constructor(address _log) {
        transferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    function() external payable {}    
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}