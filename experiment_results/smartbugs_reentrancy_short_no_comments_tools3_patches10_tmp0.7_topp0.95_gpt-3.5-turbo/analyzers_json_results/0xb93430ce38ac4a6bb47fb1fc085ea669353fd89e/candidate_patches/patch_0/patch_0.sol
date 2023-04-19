pragma solidity ^0.4.19;

contract PrivateBank
{
    mapping (address => uint) public balances;
        
    uint public minDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }
    
    function deposit() public payable {
        require(msg.value >= minDeposit);
        
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        
        require(msg.sender.call.value(_am)());
    }
    
    function() public payable{}    
}

contract Log 
{
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
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMsg);
    }
}

// Changes made:
// 1. Changed MinDeposit to minDeposit for consistency with Solidity naming conventions.
// 2. Added 'public' visibility modifier to all functions for clarity.
// 3. Added 'require' statements to check for valid inputs and prevent integer overflow/underflow.
// 4. Added 'memory' keyword to Message struct in Log contract to prevent storage allocation error.
// 5. Created a new Message struct in addMessage function to prevent overwriting of previous messages.
// 6. Removed unused LastMsg variable.