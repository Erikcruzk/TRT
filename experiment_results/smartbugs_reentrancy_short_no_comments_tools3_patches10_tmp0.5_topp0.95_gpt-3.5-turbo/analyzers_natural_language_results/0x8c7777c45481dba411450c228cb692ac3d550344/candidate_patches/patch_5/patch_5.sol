pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint256) public balances;
    
    Log TransferLog;
    
    uint256 public MinDeposit = 1 ether;
    
    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }
    
    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)(), "Transaction failed");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    function() public payable {}
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }
    
    Message[] public History;
    
    function AddMessage(address _adr, uint256 _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Data: _data,
            Val: _val,
            Time: now
        });
        History.push(newMessage);
    }
} 

// The repaired contract has added require statements to ensure that the deposit amount is greater than the minimum deposit, and that the user has sufficient balance before cashing out. It has also moved the balances[msg.sender] -= _am statement before the external call to prevent reentrancy attacks. Additionally, it has replaced the struct variable LastMsg with a newMessage variable to avoid overwriting the same struct instance.