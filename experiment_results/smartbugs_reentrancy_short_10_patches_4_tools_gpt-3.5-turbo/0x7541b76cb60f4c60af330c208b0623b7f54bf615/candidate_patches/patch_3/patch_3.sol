/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 29
 */

pragma solidity ^0.4.25;

contract U_BANK {
    function Put(uint _unlockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        emit LogFile_AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            acc.balance -= _am;
            emit LogFile_AddMessage(msg.sender, _am, "Collect");
            require(msg.sender.call.value(_am)());
        }
    }

    function() public payable {
        Put(0);
    }

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
}


contract Log {
    struct Message {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }

    Message[] public History;

    Message LastMsg;

    function LogFile_AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added 'require' statement before sending ether in Collect function.
// 2. Emit event instead of calling function in Log contract.
// 3. Modified constructor to match the new syntax.