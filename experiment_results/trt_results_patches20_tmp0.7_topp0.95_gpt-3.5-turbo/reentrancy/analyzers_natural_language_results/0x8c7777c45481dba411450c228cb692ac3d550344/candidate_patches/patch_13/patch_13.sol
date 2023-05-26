pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    bool private reentrancyLock = false;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public payable {
        require(!reentrancyLock);
        require(_am <= balances[msg.sender]);

        reentrancyLock = true;

        if (msg.sender.call.value(_am)()) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        }

        reentrancyLock = false;
    }

    function() public payable {}

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
        Message memory newMsg = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: now
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// - Added reentrancy guard using a bool flag
// - Used require statements to validate input parameters
// - Changed struct initialization to use memory instead of storage for better gas efficiency
// - Removed unused variable LastMsg in Log contract