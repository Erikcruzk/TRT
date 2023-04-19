pragma solidity ^0.5.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    uint lastBlock;
    
    constructor(address _log) public {
        transferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than minimum deposit amount.");
        
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Cash out amount should be less than or equal to user's balance.");
        require(block.number > lastBlock, "Cash out not allowed. Please try after some time.");
        
        balances[msg.sender] -= _am;
        if(msg.sender.send(_am)) {
            transferLog.addMessage(msg.sender, _am, "CashOut");
        }
    }
    
    function() external payable {}    
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
}