pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile Log;

    bool initialized;

    function SetMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function SetLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }

    function Initialize() public {
        initialized = true;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function Collect(uint _am) public {
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
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            val: _val,
            data: _data,
            time: now
        });
        history.push(newMessage);
    }
}

/*
Changes Made:
- Changed function name from Initialized to Initialize
- Changed bool variable name from intitalized to initialized
- Added require statements for validation
- Replaced call function with transfer function in Collect function to prevent re-entrancy vulnerability
- Changed variable names to follow Solidity naming convention
- Changed LogFile struct variable names to follow Solidity naming convention
- Changed LogFile function name to follow Solidity naming convention
- Updated LogFile AddMessage function to use memory keyword for struct variable
- Made minor code formatting changes for readability
*/