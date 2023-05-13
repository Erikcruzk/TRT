pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

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
        string data;
        uint val;
        uint time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message(_adr, _data, _val, now);
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed the function names to follow the Solidity naming convention.
// 2. Removed the reentrancy vulnerability in the 'collect' function by using the 'transfer' method instead of 'call'.
// 3. Removed the 'payable' modifier from the 'collect' function as it is not necessary.
// 4. Added the 'require' statement in the 'collect' function to check if the conditions for withdrawal are met.
// 5. Moved the 'Holder' struct and 'Acc' mapping above the 'Log' contract to avoid compilation errors. 
// 6. Changed the 'LogFile' variable in the 'MY_BANK' constructor to receive a 'Log' contract address instead of a 'Log' contract instance.