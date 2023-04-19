pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log transferLog;
    
    uint public minDeposit = 1 ether;
    
    constructor(address _log) {
        transferLog = new Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        bool success = payable(msg.sender).send(_am);
        require(success, "Failed to send Ether");
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
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
        Message memory message = Message(_adr, _data, _val, block.timestamp);
        history.push(message);
    }
}