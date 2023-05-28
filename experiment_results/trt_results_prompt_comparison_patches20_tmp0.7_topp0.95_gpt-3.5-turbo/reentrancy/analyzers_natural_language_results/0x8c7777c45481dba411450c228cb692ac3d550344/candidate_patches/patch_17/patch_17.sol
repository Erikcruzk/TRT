pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;
    Log TransferLog;
    uint public MinDeposit = 1 ether;
    bool private locked;

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public noReentrancy {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if (!msg.sender.send(_am)) {
                balances[msg.sender] += _am;
            } else {
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
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
    Message private LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a noReentrancy modifier to the CashOut function to prevent reentrancy attack
// 2. Changed the comparison operator in the Deposit function to >= to ensure that the minimum deposit value is met
// 3. Reordered the if-else statements in the CashOut function to first update the balances before sending the ether to prevent potential reentrancy attack
// 4. Made the LastMsg variable in the Log contract private to prevent external access and modification.