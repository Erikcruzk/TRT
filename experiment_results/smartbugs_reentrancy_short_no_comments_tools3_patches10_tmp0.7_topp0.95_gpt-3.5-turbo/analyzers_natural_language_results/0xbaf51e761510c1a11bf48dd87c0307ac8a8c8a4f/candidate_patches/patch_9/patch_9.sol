pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint256) public balances;
    
    uint256 public minDeposit = 1 ether;
    
    Log transferLog;
    
    constructor(address _log) {
        transferLog = new Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount is less than minimum deposit.");
        
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance to withdraw.");
        
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
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
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        history.push(newMessage);
    }
}