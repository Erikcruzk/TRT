pragma solidity ^0.5.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    constructor(address _log) public {
        TransferLog = new Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Not enough balance to cash out");
        require(block.number > lastBlock, "Cannot cash out before last block");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}