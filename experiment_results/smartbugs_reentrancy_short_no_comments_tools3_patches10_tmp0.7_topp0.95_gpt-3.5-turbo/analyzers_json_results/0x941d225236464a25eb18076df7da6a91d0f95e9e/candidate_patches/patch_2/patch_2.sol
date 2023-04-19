pragma solidity ^0.8.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    uint lastBlock;
    
    constructor(address _log) {
        transferLog = new Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be more than minimum deposit.");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }
    
    function cashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        require(block.number > lastBlock, "Cannot cash out before the last block.");
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
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
        Message memory newMessage = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Added constructor in the ETH_FUND contract to initialize the Log contract.
// 2. Changed function names to follow the Solidity naming convention.
// 3. Used require statements to handle errors and ensure safe execution of the contract.
// 4. Changed the transfer function to use the new Solidity syntax and added a check for transaction success.
// 5. Changed the Log contract function to use a struct instead of a global variable to store messages.