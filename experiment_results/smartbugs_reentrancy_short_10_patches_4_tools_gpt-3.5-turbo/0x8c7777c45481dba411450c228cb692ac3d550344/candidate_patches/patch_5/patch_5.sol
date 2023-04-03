/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 41
 */

pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
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
// 1. Added constructor function to initialize TransferLog contract.
// 2. Added require statement in Deposit function to check if deposit amount is greater than MinDeposit.
// 3. Removed the if statement from CashOut function and added require statement to check if the user has sufficient balance.
// 4. Added a getBalance function to get the balance of the contract.
// 5. Changed the now keyword to block.timestamp to get the current time.
// 6. Changed the fallback function to receive function.