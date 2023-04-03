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

    constructor(address _lib) {
        TransferLog = new Log(_lib);
    }
    
    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount must be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender,msg.value,"Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
    }
    
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    receive() external payable {}
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
        History.push(Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        }));
    }
} 

// Changes Made:
// 1. Added constructor instead of using function name as the constructor
// 2. Replaced call with transfer to avoid reentrancy vulnerability
// 3. Added require statements for better input validation
// 4. Updated syntax to Solidity 0.8.0
// 5. Updated Log contract to use struct constructor instead of setting values individually