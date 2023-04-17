/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 29
 */

pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    function MY_BANK(address log) public {
        LogFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        require(msg.value > 0, "Value should be greater than zero");
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        var acc = Acc[msg.sender];
        require(acc.balance >= MinSum, "Balance should be greater than MinSum");
        require(acc.balance >= _am, "Balance should be greater than the amount to collect");
        require(now > acc.unlockTime, "Unlock time should be greater than now");
        acc.balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        put(0);
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

    function addMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}