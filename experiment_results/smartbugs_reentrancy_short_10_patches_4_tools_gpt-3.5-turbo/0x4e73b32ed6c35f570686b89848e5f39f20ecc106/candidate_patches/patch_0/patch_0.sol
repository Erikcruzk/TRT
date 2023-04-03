pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping (address => uint256) public balances;
    uint public MinSum;
    LogFile Log;
    bool intitalized;

    function setMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!intitalized);
        Log = LogFile(_log);
    }

    function initialized() public {
        intitalized = true;
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
        address Sender;
        string Data;
        uint Val;
        uint Time;
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