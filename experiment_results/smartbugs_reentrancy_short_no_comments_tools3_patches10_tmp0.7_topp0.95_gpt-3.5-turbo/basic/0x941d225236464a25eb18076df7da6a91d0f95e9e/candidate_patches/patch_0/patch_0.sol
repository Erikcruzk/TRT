pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    uint lastBlock;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Amount should be less than or equal to the balance of the user");
        require(block.number > lastBlock, "Cannot CashOut now");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        payable(msg.sender).transfer(_am);
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function() external payable {}    
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
        History.push(Message(_adr, _data, _val, block.timestamp));
    }
}