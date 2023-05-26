pragma solidity ^0.4.19;

contract PENNY_BY_PENNY {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    LogFile Log;

    bool intitalized;

    modifier onlyInitialized() {
        require(intitalized);
        _;
    }

    function SetMinSum(uint _val) public onlyInitialized {
        MinSum = _val;
    }

    function SetLogFile(address _log) public onlyInitialized {
        Log = LogFile(_log);
    }

    function Initialized() public {
        intitalized = true;
    }

    function Put(uint _lockTime) public payable {
        var acc = Acc[msg.sender];
        acc.balance += msg.value;
        if (now + _lockTime > acc.unlockTime) acc.unlockTime = now + _lockTime;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable onlyInitialized {
        var acc = Acc[msg.sender];
        if (
            acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime
        ) {
            acc.balance -= _am;
            Log.AddMessage(msg.sender, _am, "Collect");
            if (!_safeTransfer(msg.sender, _am)) {
                revert();
            }
        }
    }

    function _safeTransfer(address _to, uint256 _value) private returns (bool) {
        if (!_to.call.value(_value)()) {
            return false;
        }
        return true;
    }

    function() public payable {
        Put(0);
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.Sender = _adr;
        lastMsg.Time = now;
        lastMsg.Val = _val;
        lastMsg.Data = _data;
        History.push(lastMsg);
    }
}