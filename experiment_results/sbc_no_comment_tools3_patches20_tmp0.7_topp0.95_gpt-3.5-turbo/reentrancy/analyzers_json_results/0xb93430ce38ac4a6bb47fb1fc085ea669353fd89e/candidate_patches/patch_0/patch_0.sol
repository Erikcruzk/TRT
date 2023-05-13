pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) {
        TransferLog = Log(_lib);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.addMessage(msg.sender, _am, "CashOut");
            require(msg.sender.call.value(_am)());
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}

//Changes Made:
//1. Function names have been changed to follow camelCase naming convention.
//2. Reentrancy vulnerability has been fixed by moving the state variable update before the external call and using the 'require' statement. 
//3. Added a new local variable 'lastMsg' in the addMessage function of the Log contract to avoid overwriting the values of the previous message. 
//4. Changed the variable names in the Log contract to follow camelCase naming convention.