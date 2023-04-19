pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
    }
    
    function deposit() public payable {
        if(msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _am) public {
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if(payable(msg.sender).send(_am)) {
                TransferLog.addMessage(msg.sender, _am, "CashOut");
            }
            else {
                balances[msg.sender] += _am;
            }
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
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        History.push(newMessage);
    }
} 

// Changes Made:
// - Changed the contract name to CamelCase convention
// - Added constructor keyword to the constructor function
// - Used new keyword to create an instance of the Log contract
// - Changed function names to camelCase convention
// - Changed msg.sender.call.value() to payable(msg.sender).send()
// - Added an else statement to handle failed transactions in cashOut() function
// - Used memory keyword for string parameter in addMessage() function
// - Added block.timestamp to store the current time in addMessage() function