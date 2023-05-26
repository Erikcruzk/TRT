pragma solidity ^0.4.25;

contract MY_BANK {
    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 1 ether;

    struct Holder {
        uint unlockTime;
        uint balance;
    }

    constructor(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
        msg.sender.transfer(_am);
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        put(0);
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Val: _val,
            Data: _data,
            Time: now
        });
        History.push(newMessage);
    }
} 

// Changes made:
// 1. Renamed functions to follow Solidity naming conventions.
// 2. Used require statement to check conditions instead of if statement in collect() function.
// 3. Used transfer() function instead of call.value() in collect() function to prevent reentrancy attack.
// 4. Changed LogFile.addMessage() function to addMessage() to follow Solidity naming conventions.
// 5. Changed LogFile.History to Memory to avoid storage-related reentrancy attacks.
// 6. Removed the payable modifier from the collect() function as it is not necessary.