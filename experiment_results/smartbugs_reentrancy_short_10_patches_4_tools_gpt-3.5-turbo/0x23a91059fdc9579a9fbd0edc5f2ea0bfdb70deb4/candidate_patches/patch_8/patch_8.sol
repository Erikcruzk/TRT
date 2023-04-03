/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 38
 */

pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function CashOut(uint _am) public {
        if(_am<=balances[msg.sender]) {            
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            (bool success,) = msg.sender.call{value: _am}("");
            require(success, "Transfer failed.");
        }
    }
    
    function() external payable {}    
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    Message LastMsg;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to 0.8.0.
// 2. Added constructor keyword to the constructor function.
// 3. Changed the type of TransferLog from address to Log.
// 4. Added a new Log contract.
// 5. Changed the CashOut function to first update the balance and then transfer the amount to the sender's address.
// 6. Added a require statement to check if the transfer was successful.