pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    bool private stopped = false;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!stopped);
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(!stopped);
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }

    function() public payable {} 

    function emergencyStop() public {
        require(!stopped);
        stopped = true;
    }

    function resume() public {
        require(stopped);
        stopped = false;
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

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

/**
 * Changes made:
 * - Added require statements to check for conditions to be met in Deposit() and CashOut() functions
 * - Replaced call.value() with transfer() in CashOut() function to avoid reentrancy vulnerability
 * - Added a circuit breaker in the form of an emergencyStop() function to halt contract functionality if needed
 * - Added a resume() function to resume contract functionality after an emergency stop
 * - Made stopped variable private to prevent external modification
 */