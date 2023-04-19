pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 2 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string  data;
        uint val;
        uint  time;
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

// Changes Made:
// 1. Renamed function names to follow Solidity naming convention.
// 2. Removed unnecessary 'payable' modifier from collect function.
// 3. Added 'require' statement to check if the user has sufficient balance and if it is time to unlock the balance.
// 4. Moved the state change before the external function call to prevent reentrancy attack.
// 5. Replaced 'var' with 'Holder storage' to explicitly specify the storage location of the struct variable.
// 6. Moved the struct definition to the top to follow Solidity coding standards.
// 7. Added constructor keyword to the constructor function.
// 8. Added memory keyword to the lastMsg variable to explicitly specify the memory location of the struct variable.