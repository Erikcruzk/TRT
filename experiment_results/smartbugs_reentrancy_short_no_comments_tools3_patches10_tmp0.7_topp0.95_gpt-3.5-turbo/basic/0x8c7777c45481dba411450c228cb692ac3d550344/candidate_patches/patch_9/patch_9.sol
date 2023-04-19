pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log transferLog;
    
    uint public minDeposit = 1 ether;
    
    constructor(address _log) {
        transferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than minimum deposit.");
        
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }
    
    receive() external payable {}    
    
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