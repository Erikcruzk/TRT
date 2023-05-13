pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool intitialized;

    function SetMinSum(uint _val) public {
        require(!intitialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!intitialized);
        Log = LogFile(_log);
    }

    function Initialized() public {
        intitialized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am); // Adding require statement to check if the user has sufficient balance and MinSum is greater than or equal to the transaction amount
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am); // Transfer the amount to the user after updating the balance and logging the message
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
        Message memory LastMsg; // Create a new memory variable to store the message
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}