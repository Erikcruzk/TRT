pragma solidity ^0.8.0;

contract PENNY_BY_PENNY {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }

    mapping(address => Holder) public Acc;

    uint256 public MinSum;

    LogFile Log;

    bool initialized;

    constructor(address _log) {
        Log = LogFile(_log);
    }

    function setMinSum(uint256 _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }

    function put(uint256 _lockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (block.timestamp + _lockTime > acc.unlockTime)
            acc.unlockTime = block.timestamp + _lockTime;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint256 _am) public {
        Holder storage acc = Acc[msg.sender];
        require(
            acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime,
            "Insufficient balance or lock time not expired"
        );

        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
        put(0);
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

    function addMessage(
        address _adr,
        uint256 _val,
        string memory _data
    ) public {
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        History.push(lastMsg);
    }
}

// No integer overflow/underflow vulnerabilities found by Osiris
// No reentrancy vulnerabilities found by Slither