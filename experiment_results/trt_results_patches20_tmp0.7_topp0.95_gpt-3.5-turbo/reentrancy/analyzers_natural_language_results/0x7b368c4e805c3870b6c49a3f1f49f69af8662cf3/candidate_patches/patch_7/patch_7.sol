pragma solidity ^0.4.25;

contract W_WALLET {
    function Put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        require(
            Acc[msg.sender].balance >= MinSum && Acc[msg.sender].balance >= _am && now > Acc[msg.sender].unlockTime,
            "Insufficient balance or lock time not expired"
        );
        Acc[msg.sender].balance -= _am;
        if (!msg.sender.send(_am)) {
            revert("Failed to send ether");
        }
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }

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
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Removed unnecessary variable assignment
// 2. Replaced the external call with send() function in Collect() function
// 3. Added require statement to check for sufficient balance and lock time before executing the transfer of ether in Collect() function
// 4. Used constructor instead of function with the same name as the contract
// 5. Modified AddMessage() function in Log contract to use memory instead of storage for newMsg variable and removed LastMsg variable.