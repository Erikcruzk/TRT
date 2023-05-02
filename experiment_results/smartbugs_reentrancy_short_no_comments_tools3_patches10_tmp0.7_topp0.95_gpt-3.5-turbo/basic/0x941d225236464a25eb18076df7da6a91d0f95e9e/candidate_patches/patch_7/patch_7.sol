pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    function ETH_FUND(address _log) public {
        TransferLog = new Log();
    }
    
    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        require(block.number > lastBlock);
        require(msg.sender.call.value(_am)());
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    function() public payable {}    
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
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