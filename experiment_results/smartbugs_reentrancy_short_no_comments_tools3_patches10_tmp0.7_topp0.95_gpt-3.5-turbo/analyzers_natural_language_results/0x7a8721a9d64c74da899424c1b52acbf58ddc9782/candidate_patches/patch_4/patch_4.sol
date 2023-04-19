pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint256) public balances;
        
    uint256 public minDeposit = 1 ether;
    address public owner;
    
    Log transferLog;
    
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
        require(msg.value >= minDeposit, "Deposit amount should be greater than or equal to minDeposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    receive() external payable {}    
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        history.push(lastMsg);
    }
}