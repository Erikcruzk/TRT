/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 40
 */

pragma solidity ^0.4.19;

contract Private_Bank {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        require(msg.sender.call.value(_am)());
    }

    function() public payable{}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: now
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added visibility modifiers to functions.
// 2. Used require statements to validate conditions.
// 3. Removed the re-entrancy vulnerability by transferring funds after logging the transaction. 
// 4. Used a struct to add new messages to the message history.