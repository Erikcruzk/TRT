pragma solidity ^0.8.0;

contract MONEY_BOX {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }

    mapping(address => Holder) public Acc;

    uint256 public MinSum;

    Log LogFile;

    bool intitalized;

    constructor() {
        intitalized = false;
    }

    function SetMinSum(uint256 _val) public {
        require(!intitalized, "Already initialized");
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!intitalized, "Already initialized");
        LogFile = Log(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Put(uint256 _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime)
            acc.unlockTime = block.timestamp + _lockTime;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint256 _am) public payable {
        Holder storage acc = Acc[msg.sender];
        if (
            acc.balance >= MinSum &&
            acc.balance >= _am &&
            block.timestamp > acc.unlockTime
        ) {
            (bool success, ) = msg.sender.call{value: _am}("");
            require(success, "Transfer failed.");
            acc.balance -= _am;
            LogFile.AddMessage(msg.sender, _am, "Collect");
        }
    }

    function() external payable {
        Put(0);
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

    function AddMessage(address _adr, uint256 _val, string memory _data)
        public
    {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}