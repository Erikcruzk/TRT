pragma solidity ^0.4.19;

contract DEP_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    modifier onlyWhenNotInitialized() {
        require(!initialized, "Already initialized");
        _;
    }

    function setMinSum(uint _val) public onlyWhenNotInitialized {
        MinSum = _val;
    }

    function setLogFile(address _log) public onlyWhenNotInitialized {
        Log = LogFile(_log);
    }

    function initialize() public onlyWhenNotInitialized {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(initialized, "Not initialized");
        require(balances[msg.sender] >= MinSum, "Balance is less than minimum sum");
        require(balances[msg.sender] >= _am, "Balance is less than withdrawal amount");

        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");

        msg.sender.transfer(_am);
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