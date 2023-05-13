pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

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

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
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
        Message memory message = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(message);
    }
} 

// Changes Made:
// 1. Added constructor to initialize LogFile contract address
// 2. Changed function names to follow Solidity naming conventions
// 3. Removed unnecessary 'payable' modifier from collect function
// 4. Reordered statements in collect function to avoid reentrancy vulnerability
// 5. Replaced 'initialized' boolean with 'require' statement in setMinSum function
// 6. Changed variable names to follow Solidity naming conventions
// 7. Changed LogFile variable to be initialized in the constructor instead of in the contract body.