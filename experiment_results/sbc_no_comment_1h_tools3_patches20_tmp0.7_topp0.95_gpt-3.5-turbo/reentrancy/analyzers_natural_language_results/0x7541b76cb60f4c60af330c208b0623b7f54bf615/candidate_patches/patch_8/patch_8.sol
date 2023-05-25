pragma solidity ^0.4.25;

contract U_BANK {
    mapping(address => uint) public balances;
    mapping(address => uint) public unlockTimes;
    Log public log;
    uint public minSum = 2 ether;

    function U_BANK(address _log) public {
        log = Log(_log);
    }

    function put(uint _unlockTime) public payable {
        balances[msg.sender] += msg.value;
        unlockTimes[msg.sender] = _unlockTime > now ? _unlockTime : now;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am && now > unlockTimes[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        log.addMessage(msg.sender, _am, "Collect");
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
        history.push(Message(_adr, _data, _val, now));
    }
} 

// Replaced the struct Holder with two mappings to store the balance and unlock time separately
// Added a require statement in the collect function to prevent reentrancy attack
// Removed the payable modifier from the collect function as it is not necessary
// Replaced var with the appropriate data type in the functions
// Changed the function names to follow the Solidity style guide
// Added a visibility modifier to the Log contract's addMessage function to make it public.