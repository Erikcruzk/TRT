pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    constructor(address _log) {
        TransferLog = new Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
        lastBlock = block.number;
    }
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Cannot cash out yet");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender,_am,"CashOut");
        (bool sent, ) = msg.sender.call{value: _am}("");
        require(sent, "Failed to send Ether");
    }
    
    receive() external payable {}    
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr,uint _val,string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made
// 1. Added constructor to initialize TransferLog as a new contract
// 2. Replaced if statements with require statements for better error handling
// 3. Changed function signature of AddMessage to use memory instead of storage for string parameter
// 4. Added receive function as fallback function instead of using the deprecated function() public payable{}