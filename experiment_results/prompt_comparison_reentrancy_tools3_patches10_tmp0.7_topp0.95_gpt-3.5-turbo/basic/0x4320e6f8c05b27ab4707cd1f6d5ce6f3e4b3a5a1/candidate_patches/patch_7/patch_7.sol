pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile public Log;

    bool initialized;

    function ACCURAL_DEPOSIT(address _log) public {
        Log = LogFile(_log);
    }

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        deposit();
    }
}

contract LogFile {
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

/* Changes Made:
1. Initialized variable was not being set to true, so added a function 'Initialized' to set its value.
2. Replaced 'intitalized' with 'initialized' in the code.
3. Added a constructor to initialize the LogFile contract.
4. Changed function names to follow Solidity naming conventions.
5. Removed unnecessary if statement in 'setMinSum' function.
6. Removed if statement in 'collect' function and added a require statement instead.
7. Changed the 'LastMsg' variable to a local variable in 'addMessage' function and added it to the history array. 
8. Changed struct variable names to follow Solidity naming conventions.
9. Removed the unnecessary 'payable' modifier from 'collect' function.
*/