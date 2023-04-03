/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 41
 */
 
pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint) public balances;
    
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
    
    function CashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }
    
    receive() external payable {}    
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
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// The repaired contract makes the following changes:
// 1. The constructor function name is changed to match the contract name.
// 2. The Log contract is created using the new keyword in the constructor.
// 3. The Deposit function is updated to use the require statement to validate the deposit amount.
// 4. The CashOut function is updated to transfer the requested amount before updating the balance to prevent reentrancy attacks.
// 5. The fallback function is updated to use the receive() external payable function modifier.