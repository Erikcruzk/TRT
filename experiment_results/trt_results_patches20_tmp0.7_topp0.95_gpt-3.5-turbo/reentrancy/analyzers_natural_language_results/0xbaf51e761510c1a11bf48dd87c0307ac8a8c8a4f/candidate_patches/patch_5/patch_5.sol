pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    bool private reentrancy_lock = false;

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
        require(!reentrancy_lock);
        require(_am <= balances[msg.sender]);
        reentrancy_lock = true;
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        reentrancy_lock = false;
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// Changes made:
// 1. Added reentrancy_lock to prevent reentrancy attack
// 2. Replaced msg.sender.call.value with msg.sender.transfer to prevent reentrancy attack
// 3. Moved the creation of LastMsg struct to AddMessage function to prevent overwriting of data
// 4. Removed unnecessary public visibility from LastMsg struct and its elements