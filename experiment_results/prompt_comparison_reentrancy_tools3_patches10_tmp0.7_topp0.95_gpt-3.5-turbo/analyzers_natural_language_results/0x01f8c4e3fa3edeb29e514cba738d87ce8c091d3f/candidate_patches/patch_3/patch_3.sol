pragma solidity ^0.8.0;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

    constructor(address _log) {
        Log = LogFile(_log);
    }

    function setMinSum(uint _val) public {
        require(!initialized, "Already initialized");
        MinSum = _val;
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Deposit");
    }

    fallback() external payable {
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

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        history.push(newMessage);
    }
}