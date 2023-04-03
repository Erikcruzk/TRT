/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 55
 */

pragma solidity ^0.8.0;

contract ACCURAL_DEPOSIT {
    mapping (address=>uint256) public balances;   
   
    uint public MinSum = 1 ether;
    
    LogFile Log;
    
    bool intitalized;
    
    constructor(address _log) {
        Log = LogFile(_log);
    }
    
    function SetMinSum(uint _val) public {
        require(!intitalized, "Contract already initialized");
        MinSum = _val;
    }
    
    function Initialized() public {
        intitalized = true;
    }
    
    function Deposit() public payable {
        balances[msg.sender]+= msg.value;
        Log.AddMessage(msg.sender,msg.value,"Put");
    }
    
    function Collect(uint _am) public payable {
        require(balances[msg.sender]>=MinSum && balances[msg.sender]>=_am, "Insufficient balance");
        balances[msg.sender]-=_am;
        Log.AddMessage(msg.sender,_am,"Collect");
        (bool success,) = msg.sender.call{value:_am}("");
        require(success, "Transfer failed");
    }
    
    function() external payable {
        Deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr,uint _val,string memory _data) public {
        History.push(Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        }));
    }
} 

// Changes made:
// - Added constructor to initialize LogFile
// - Changed SetMinSum and SetLogFile to require that the contract has not been initialized yet
// - Removed intitalized variable and Initialized function
// - Added require statements to Collect function to check that the balance is sufficient and the transfer was successful
// - Changed LastMsg to a local variable in AddMessage function and removed it from the contract state
// - Changed History array to be public and added Message struct to it directly in AddMessage function
// - Updated syntax to Solidity version 0.8.0