pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint256) public balances;
    
    uint256 public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        TransferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    function() public payable {}    
}

contract Log {
   
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint256 _val, string _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
}