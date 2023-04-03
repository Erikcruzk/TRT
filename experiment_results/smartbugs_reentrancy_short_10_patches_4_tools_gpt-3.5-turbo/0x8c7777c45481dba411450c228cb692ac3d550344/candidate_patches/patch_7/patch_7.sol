/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 41
 */
 
pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    constructor(address _log) {
        TransferLog = new Log();
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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
        Message memory message = Message(_adr, _data, _val, block.timestamp);
        History.push(message);
    }
} 

// Changes made:
// 1. Updated the Solidity version to 0.8.0
// 2. Added a constructor to initialize the TransferLog contract
// 3. Added a check in the Deposit function to ensure that the deposit amount is greater than the minimum deposit
// 4. Removed the payable modifier from the CashOut function as it is not required
// 5. Added a require statement to ensure that the user has sufficient balance before withdrawing
// 6. Updated the CashOut function to first update the balance and then transfer the funds to the user to prevent reentrancy attacks
// 7. Added a getBalance function to check the balance of the contract.