pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// I have made the following changes:
// 1. Replaced the call function with transfer in CashOut to prevent reentrancy attack
// 2. Added require statements to ensure that the minimum deposit is met and that the user has sufficient balance to cash out
// 3. Removed the payable modifier from CashOut as it is not necessary since the function does not receive any ether
// 4. Moved the function() public payable {} to the end of the contract to improve readability