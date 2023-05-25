pragma solidity ^0.8.0;

contract PersonalBank {
    mapping(address => uint256) public balances;

    uint256 public minSum = 1 ether;

    LogFile public log;

    bool private initialized;

    constructor(address logAddress) {
        log = LogFile(logAddress);
    }

    function setMinSum(uint256 _val) external {
        require(!initialized, "Already initialized");
        minSum = _val;
    }

    function setLogFile(address _log) external {
        require(!initialized, "Already initialized");
        log = LogFile(_log);
    }

    function initialize() external {
        initialized = true;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) external payable {
        require(balances[msg.sender] >= minSum, "Insufficient balance");
        require(balances[msg.sender] >= _am, "Requested amount greater than balance");

        balances[msg.sender] -= _am;

        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");

        log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        deposit();
    }
}

contract LogFile {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory msg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });

        history.push(msg);
    }
}