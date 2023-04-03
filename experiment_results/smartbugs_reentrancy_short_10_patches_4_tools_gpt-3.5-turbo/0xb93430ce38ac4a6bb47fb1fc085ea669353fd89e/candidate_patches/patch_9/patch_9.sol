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
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount is less than minimum deposit amount");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Withdrawal amount is greater than balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
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

    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
}

// Changes Made:
// 1. Added constructor to initialize the Log contract.
// 2. Changed the function modifier to require for better error handling.
// 3. Removed the vulnerability of reentrancy by transferring the balance before sending the ether.