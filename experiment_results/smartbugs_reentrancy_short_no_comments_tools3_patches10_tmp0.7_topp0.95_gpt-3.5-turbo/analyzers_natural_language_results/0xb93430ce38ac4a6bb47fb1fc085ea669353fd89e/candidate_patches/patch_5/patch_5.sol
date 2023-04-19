pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint256) public balances;
        
    uint256 public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _lib) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than or equal to minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance to withdraw");
        balances[msg.sender] -= _am;
        payable(msg.sender).transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    receive() external payable {}    
}

contract Log {
   
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        History.push(Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        }));
    }
} 

// Changes made:
// 1. Updated the Solidity version to 0.8.0
// 2. Added constructor function for initializing TransferLog
// 3. Used require statements for input validations
// 4. Changed the CashOut function to transfer the requested amount to the caller instead of using call.value
// 5. Changed the AddMessage function to push a new struct object to the History array instead of modifying a single LastMsg object.