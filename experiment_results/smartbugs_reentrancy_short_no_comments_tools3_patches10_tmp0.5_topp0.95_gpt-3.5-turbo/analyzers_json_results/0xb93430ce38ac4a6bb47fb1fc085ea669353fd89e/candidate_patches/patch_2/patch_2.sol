pragma solidity ^0.4.19;

contract PrivateBank {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    bool private stopped = false;
    
    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }
    
    function Deposit() public payable {
        require(!stopped);
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }
    
    function CashOut(uint _am) public {
        require(!stopped);
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }
    
    function() public payable {
        require(!stopped);
    }
    
    function toggleContractActive() public {
        require(msg.sender == 0x0); // Replace 0x0 with the address of the contract owner
        stopped = !stopped;
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
    
    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added a circuit breaker to stop the contract from executing any further.
// 2. Added require statements to validate the inputs and prevent errors.
// 3. Replaced the call function with the transfer function to prevent reentrancy attacks.
// 4. Modified the AddMessage function to use a memory struct instead of a storage struct.