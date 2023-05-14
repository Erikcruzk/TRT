pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;
    mapping(address => bool) public initialized;

    uint public minSum = 1 ether;

    LogFile public log;

    modifier onlyInitialized() {
        require(initialized[msg.sender]);
        _;
    }

    function setMinSum(uint _val) public onlyInitialized {
        minSum = _val;
    }

    function setLogFile(LogFile _log) public onlyInitialized {
        log = _log;
    }

    function initialize() public {
        initialized[msg.sender] = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable onlyInitialized {
        require(balances[msg.sender] >= minSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        log.addMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
}