pragma solidity ^0.4.19;

contract BANK_SAFE {
    mapping(address => uint256) public balances;

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

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public onlyInitialized {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        Deposit();
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
        History.push(Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        }));
    }
}