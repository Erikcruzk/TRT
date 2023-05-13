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
        require(initialized);
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            Log.addMessage(msg.sender, _am, "Collect");
        } else {
            balances[msg.sender] += _am;
        }
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes made:
// 1. Added constructor to initialize LogFile contract
// 2. Renamed functions to follow Solidity naming conventions (lowercase for functions and camelCase for variables)
// 3. Changed 'intitalized' to 'initialized' in the contract
// 4. Replaced 'if (intitalized) revert()' with 'require(!initialized)' to prevent re-initialization
// 5. Moved 'initialized' check to 'collect' function to prevent unauthorized withdrawals
// 6. Moved balance deduction before the 'call' function in 'collect' function to prevent re-entry attacks
// 7. Added 'else' statement to refund balance if 'call' function fails in 'collect' function
// 8. Changed LogFile's 'History' variable to 'history' to follow Solidity naming conventions
// 9. Changed LogFile's 'Message' struct variables to follow Solidity naming conventions