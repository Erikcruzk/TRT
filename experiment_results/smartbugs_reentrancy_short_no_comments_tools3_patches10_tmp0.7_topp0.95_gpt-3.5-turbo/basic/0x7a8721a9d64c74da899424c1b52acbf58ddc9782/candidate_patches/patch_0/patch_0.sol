pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint) public balances;
        
    uint public minDeposit = 1 ether;
    address public owner;
    
    Log public transferLog;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }    
    
    constructor() {
        owner = msg.sender;
        transferLog = new Log();
    }
    
    function setLog(address _lib) public onlyOwner {
        transferLog = Log(_lib);
    }    
    
    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount should be greater than or equal to minimum deposit amount");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value:_am}("");
        require(success, "Transfer failed.");
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    receive() external payable {}    
    
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}