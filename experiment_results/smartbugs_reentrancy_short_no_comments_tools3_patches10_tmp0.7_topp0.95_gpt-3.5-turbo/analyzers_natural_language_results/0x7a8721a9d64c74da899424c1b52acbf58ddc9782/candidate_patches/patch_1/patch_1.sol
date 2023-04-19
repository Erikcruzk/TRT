pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint) public balances;
        
    uint public MinDeposit = 1 ether;
    address public owner;
    
    Log public TransferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }    
    
    constructor() {
        owner = msg.sender;
        TransferLog = new Log();
    }
    
    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        require(msg.value >= MinDeposit, "Amount sent is less than minimum deposit amount");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance for withdrawal");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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