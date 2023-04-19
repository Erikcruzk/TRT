pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    uint lastBlock;
    
    constructor(address _log) {
        transferLog = Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount is less than minimum deposit amount.");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        require(block.number > lastBlock, "Cannot cash out before the last deposit.");
        balances[msg.sender] -= _am;
        payable(msg.sender).transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
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
        Message memory newMsg = Message(_adr, _data, _val, block.timestamp);
        history.push(newMsg);
    }
}