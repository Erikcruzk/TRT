pragma solidity ^0.8.0;

contract Private_Bank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit.");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        payable(msg.sender).transfer(_am);
    }
    
    function getBalance() public view returns(uint) {
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
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        history.push(newMessage);
    }
}