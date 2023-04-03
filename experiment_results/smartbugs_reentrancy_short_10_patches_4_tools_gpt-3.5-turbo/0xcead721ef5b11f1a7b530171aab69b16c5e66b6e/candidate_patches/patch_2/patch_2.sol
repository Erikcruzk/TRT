/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 29
 */

pragma solidity ^0.4.25;

contract WALLET {
    function Put(uint _unlockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        emit LogFileAddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        if (acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime) {
            // <yes> <report> REENTRANCY
            acc.balance -= _am;
            emit LogFileAddMessage(msg.sender, _am, "Collect");
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

    uint public MinSum = 1 ether;

    constructor(address log) public {
        LogFile = Log(log);
    }

    event LogFileAddMessage(address indexed sender, uint value, string data);
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}