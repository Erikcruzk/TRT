pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping(address => Holder) public Acc;
    Log LogFile;
    uint public MinSum = 2 ether;

    event LogMessage(address indexed sender, uint value, string data);

    constructor(address log) public {
        LogFile = Log(log);
    }
    
    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        emit LogMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime);
        Acc[msg.sender].balance -= _am;
        emit LogMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }
} 

/* Changes Made:
1. Added event LogMessage to log the messages.
2. Made the functions put and collect to follow the proper naming convention.
3. Changed the visibility modifier of collect function to public and added a require statement to check the conditions.
4. Moved the struct Holder and the mapping Acc above the functions.
5. Added a constructor to initialize the LogFile.
6. Removed the reentrancy vulnerability by transferring the amount to the user after updating the balance.
7. Removed the use of the deprecated var keyword.