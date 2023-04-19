pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    address public owner;
    Log private TransferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }    
    
    constructor() {
        owner = msg.sender;
        TransferLog = new Log();
    }
    
    function setLog(address _lib) external onlyOwner {
        TransferLog = Log(_lib);
    }    
    
    function deposit() external payable {
        require(msg.value >= MinDeposit, "Minimum deposit is required");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) external {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
}