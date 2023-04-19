pragma solidity ^0.8.0;

contract W_WALLET
{
    struct Holder   
    {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;    

    constructor(address log) {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime)
    public
    payable
    {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        LogFile.AddMessage(msg.sender,msg.value,"Put");
    }

    function Collect(uint _am)
    public
    {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or unlock time not reached");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        LogFile.AddMessage(msg.sender,_am,"Collect");
    }

    function() 
    external 
    payable
    {
        Put(0);
    }
}


contract Log 
{
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    function AddMessage(address _adr,uint _val,string memory _data)
    public
    {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Upgraded to Solidity 0.8.0
// 2. Moved the struct Holder above the mapping Acc
// 3. Changed the constructor name to match the contract name
// 4. Changed now to block.timestamp
// 5. Removed unnecessary payable modifier from Collect function
// 6. Added require statements to check for sufficient balance and unlock time
// 7. Changed the way variables are declared and assigned to comply with latest Solidity best practices
// 8. Added visibility modifier to fallback function
// 9. Replaced LastMsg with a new struct in the Log contract and created a new Message struct for each log entry.