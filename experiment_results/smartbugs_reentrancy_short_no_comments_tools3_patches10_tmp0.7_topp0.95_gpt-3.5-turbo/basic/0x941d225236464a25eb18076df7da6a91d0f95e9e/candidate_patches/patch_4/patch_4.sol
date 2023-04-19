pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping (address => uint) public balances;
    uint public minDeposit = 1 ether;
    Log transferLog;
    uint lastBlock;
    
    function ETH_FUND(address _log) public {
        transferLog = new Log(_log);
    }
    
    function deposit() public payable {
        if(msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
    }
    
    function cashOut(uint _am) public {
        if(_am <= balances[msg.sender] && block.number > lastBlock) {
            if(msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
                transferLog.addMessage(msg.sender, _am, "CashOut");
            }
        }
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}