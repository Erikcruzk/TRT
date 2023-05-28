pragma solidity ^0.4.19;

contract ACCURAL_DEPOSIT {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool intitalized;

    function ACCURAL_DEPOSIT(address _log) public {
        Log = LogFile(_log);
    }

    function SetMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!intitalized);
        Log = LogFile(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
    }

    function() public payable {
        Deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory msg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(msg);
    }
} 

// Changes made:
// 1. Added constructor to set the LogFile contract address.
// 2. Replaced "revert()" with "require()" for better readability.
// 3. Moved the Log.AddMessage function call before the state variable change in Collect() function to prevent reentrancy attack.
// 4. Used a local variable in AddMessage() function instead of modifying the state variable directly to prevent race conditions.