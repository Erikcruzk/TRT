pragma solidity ^0.8.0;

contract MONEY_BOX {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }

    mapping (address => Holder) public Acc;

    uint256 public MinSum;

    Log LogFile;

    bool public intitalized;

    function setMinSum(uint256 _val) public {
        require(!intitalized, "Already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!intitalized, "Already initialized");
        LogFile = Log(_log);
    }

    function initialized() public {
        intitalized = true;
    }

    function put(uint256 _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (block.timestamp + _lockTime > acc.unlockTime) {
            acc.unlockTime = block.timestamp + _lockTime;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Invalid balance or unlock time");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        LogFile.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
        put(0);
    }
}


contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMsg;
        newMsg.Sender = _adr;
        newMsg.Time = block.timestamp;
        newMsg.Val = _val;
        newMsg.Data = _data;
        History.push(newMsg);
    }
}