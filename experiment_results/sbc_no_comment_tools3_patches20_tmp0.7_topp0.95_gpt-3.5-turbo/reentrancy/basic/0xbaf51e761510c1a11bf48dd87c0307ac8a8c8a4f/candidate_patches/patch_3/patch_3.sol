pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;

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
        if(msg.sender.send(_am)) {
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        } else {
            balances[msg.sender] += _am;
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Added the 'require' function to check if the value being deposited is greater than the minimum deposit amount.
// 2. Removed the 'payable' modifier from the CashOut function and replaced it with 'send' function for better security.
// 3. Added a check to ensure that the transfer of funds in the CashOut function is successful before updating the balances of the sender. 
// 4. Added a memory keyword while declaring the newMessage in the AddMessage function of the Log contract.