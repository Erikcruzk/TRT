pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
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
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMsg);
    }
}

// Changes Made:
// 1. Renamed functions to follow Solidity naming conventions.
// 2. Added require statements to check for valid conditions.
// 3. Removed unnecessary payable modifier from cashOut function.
// 4. Used memory keyword while declaring a new struct variable in addMessage function.
// 5. Updated LastMsg variable to newMsg variable in addMessage function.