pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;
    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, now);
        History.push(lastMsg);
    }
} 

//The following changes have been made to the contract:
//1. Changed the condition in Deposit() to >= so that the minimum deposit is 1 ether.
//2. Removed the payable modifier from CashOut() as it doesn't need to receive any ether.
//3. Replaced the external call with msg.sender.transfer(_am) to prevent reentrancy attacks.
//4. Added a require statement to check if the user has sufficient balance before withdrawing.
//5. Removed the LastMsg variable and used a local variable instead in AddMessage() function.