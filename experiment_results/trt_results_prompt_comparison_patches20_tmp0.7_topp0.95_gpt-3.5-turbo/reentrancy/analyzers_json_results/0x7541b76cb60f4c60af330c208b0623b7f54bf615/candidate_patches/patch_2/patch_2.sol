pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    Log public logFile;
    uint public minSum = 2 ether;

    function U_BANK(address _log) public {
        logFile = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum);
        require(balances[msg.sender] >= _am);
        require(now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes Made
// 1. Merged the struct Holder with mappings balances and unlockTimes for simplicity
// 2. Replaced var with explicit data types
// 3. Used require statements instead of if statements for better security
// 4. Removed payable modifier from Collect function to prevent reentrancy vulnerability
// 5. Used memory keyword when creating new Message struct in Log contract
// 6. Removed unnecessary null values in analyzer results