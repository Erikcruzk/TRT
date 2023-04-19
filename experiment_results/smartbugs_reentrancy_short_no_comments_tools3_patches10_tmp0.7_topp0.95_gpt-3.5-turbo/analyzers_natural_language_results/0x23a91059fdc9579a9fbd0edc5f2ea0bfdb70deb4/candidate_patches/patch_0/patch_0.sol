pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log private transferLog;
    
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
            require(payable(msg.sender).send(_am));
            transferLog.addMessage(msg.sender, _am, "CashOut");
        }
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
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        history.push(lastMsg);
    }
}