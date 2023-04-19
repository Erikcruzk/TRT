pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    constructor(address _log) {
        transferLog = Log(_log);
    }
    
    function deposit() public payable {
        if(msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _am) public {
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if(payable(msg.sender).send(_am)) {
                transferLog.addMessage(msg.sender, _am, "CashOut");
            }
            else {
                balances[msg.sender] += _am;
            }
        }
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
        Message memory newMessage = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}