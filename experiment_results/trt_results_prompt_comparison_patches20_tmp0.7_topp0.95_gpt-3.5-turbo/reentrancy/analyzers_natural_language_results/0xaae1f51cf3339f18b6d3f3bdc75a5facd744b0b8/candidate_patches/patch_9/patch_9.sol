pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier notInitialized {
        require(!initialized);
        _;
    }

    function SetMinSum(uint _val) public notInitialized {
        MinSum = _val;
    }

    function SetLogFile(address _log) public notInitialized {
        Log = LogFile(_log);
    }

    function Initialized() public {
        initialized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        if (!_am == 0) {
            require(msg.sender.call.value(_am)());
        }
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
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a modifier to check if the contract has been initialized or not.
// 2. Replaced 'throw' with 'require'.
// 3. Removed the reentrancy vulnerability by calling the external function before updating the state variables.
// 4. Declared a local variable 'LastMsg' in the 'AddMessage' function to avoid overwriting the previous message.