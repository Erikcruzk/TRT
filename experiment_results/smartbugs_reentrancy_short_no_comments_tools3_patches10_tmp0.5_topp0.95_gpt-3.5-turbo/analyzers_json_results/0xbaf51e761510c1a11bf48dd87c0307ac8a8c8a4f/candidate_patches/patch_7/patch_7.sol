pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    Log transferLog;
    
    constructor(address _log) {
        transferLog = new Log(_log);
    }
    
    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount must be greater than or equal to minimum deposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Cash out amount must be less than or equal to user balance");
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Cash out failed");
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
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
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed the pragma version to ^0.8.0
// 2. Renamed MinDeposit to minDeposit and made it lowercase to follow Solidity naming conventions
// 3. Added a constructor to initialize the Log contract
// 4. Changed Deposit function to use require statement instead of if statement and added error message
// 5. Changed CashOut function to use require statement instead of if statement, added error message, and moved balance update before external call to prevent reentrancy vulnerability
// 6. Added getBalance function to allow contract owner to check the contract balance
// 7. Changed LastMsg struct to newMessage struct in Log contract and added memory keyword to string parameter to fix compiler error
// 8. Changed function names to use camelCase instead of PascalCase to follow Solidity naming conventions.