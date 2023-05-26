pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool intitalized;

    modifier notInitialized() {
        require(!intitalized);
        _;
    }

    function SetMinSum(uint _val) public notInitialized {
        MinSum = _val;
    }

    function SetLogFile(address _log) public notInitialized {
        Log = LogFile(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
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
        History.push(Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        }));
    }
} 

// Changes Made:
// 1. Added a modifier 'notInitialized' to check if the contract has been initialized or not.
// 2. Removed the reentrancy vulnerability in the Collect function by first updating the balance and then transferring funds to the sender.
// 3. Modified the AddMessage function in the LogFile contract to create a new Message object instead of updating the existing one.