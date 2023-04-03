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
        if(_am <= balances[msg.sender]) {            
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            (bool success, ) = msg.sender.call{value: _am}("");
            require(success, "Transfer failed.");
        }
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = block.timestamp;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.8.0
// 2. Added constructor keyword to the constructor function
// 3. Changed the Log contract address to be created within the PrivateBank contract
// 4. Added a check for successful transfer of funds in the CashOut function using the require statement
// 5. Changed the timestamp function from now to block.timestamp in the AddMessage function of the Log contract
// 6. Added memory keyword to the newMsg variable in the AddMessage function of the Log contract.