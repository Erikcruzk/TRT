pragma solidity ^0.8.0;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;
    uint256 public MinSum = 1 ether;
    LogFile public Log;
    bool public intitalized;

    constructor(address _log) {
        Log = LogFile(_log);
    }

    function SetMinSum(uint256 _val) public {
        require(!intitalized, "Already initialized");
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!intitalized, "Already initialized");
        Log = LogFile(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint256 _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.AddMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        Deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;
    Message public LastMsg;

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}