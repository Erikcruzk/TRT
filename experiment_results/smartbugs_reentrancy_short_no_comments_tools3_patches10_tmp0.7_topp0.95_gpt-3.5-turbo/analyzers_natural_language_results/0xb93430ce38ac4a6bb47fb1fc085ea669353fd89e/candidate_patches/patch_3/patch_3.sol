pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _lib) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function CashOut(uint _am) public {
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            (bool success, ) = msg.sender.call{value: _am}("");
            require(success, "Transfer failed.");
        }
    }
    
    receive() external payable {}    
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        History.push(newMessage);
    }
}