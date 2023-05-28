pragma solidity ^0.4.25;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;

    Log logFile;

    uint public minSum = 2 ether;

    function U_BANK(address _log) public {
        logFile = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        Holder storage holder = acc[msg.sender];
        holder.balance += msg.value;
        holder.unlockTime = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage holder = acc[msg.sender];
        require(holder.balance >= minSum && holder.balance >= _am && now > holder.unlockTime);
        holder.balance -= _am;
        msg.sender.transfer(_am);
        logFile.addMessage(msg.sender, _am, "Collect");
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

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
} 

// Changes made:
// 1. Changed the variable names to follow Solidity naming conventions.
// 2. Moved the struct and mapping declarations to the top of the contract.
// 3. Changed the Collect function to use the require statement and transfer the funds instead of using an external call.
// 4. Changed the Log contract to use a memory variable instead of storage to avoid unnecessary gas costs.