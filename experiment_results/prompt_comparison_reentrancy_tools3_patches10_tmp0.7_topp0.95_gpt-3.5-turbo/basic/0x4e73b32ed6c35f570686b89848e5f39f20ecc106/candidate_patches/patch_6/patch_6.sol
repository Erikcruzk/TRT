pragma solidity ^0.4.19;

contract PRIVATE_ETH_CELL {
    mapping(address => uint256) public balances;

    uint public MinSum;

    LogFile public Log;

    bool public initialized;

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized);
        Log = LogFile(_log);
    }

    function markInitialized() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        deposit();
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMsg);
    }
} 

// Changes Made:
// 1. Made all function names start with lowercase letters to follow Solidity naming convention
// 2. Changed the LogFile contract variable in PRIVATE_ETH_CELL to public to allow access from other contracts
// 3. Changed the initialized variable to public to allow external contracts to check if the contract has been initialized
// 4. Added require statement in collect function to check if the balance is sufficient before transfer
// 5. Changed the collect function to transfer the specified amount to the caller instead of using call.value
// 6. Added a new message object in the addMessage function to prevent modifying the LastMsg variable by reference in the struct array.