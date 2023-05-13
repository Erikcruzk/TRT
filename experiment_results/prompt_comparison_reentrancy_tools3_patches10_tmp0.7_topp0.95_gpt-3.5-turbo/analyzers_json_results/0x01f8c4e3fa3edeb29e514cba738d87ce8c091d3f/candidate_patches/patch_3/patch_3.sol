pragma solidity ^0.8.0;

contract PERSONAL_BANK {
    mapping(address => uint256) public balances;

    uint public MinSum = 1 ether;

    LogFile Log;

    bool initialized;

    function setMinSum(uint _val) public {
        require(!initialized, "Contract already initialized");
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!initialized, "Contract already initialized");
        Log = LogFile(_log);
    }

    function initialize() public {
        initialized = true;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am, "Insufficient funds");
        balances[msg.sender] -= _am;
        require(payable(msg.sender).send(_am), "Transfer failed");
        Log.addMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
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
        history.push(Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        }));
    }
} 

// Changes Made:
// 1. Updated pragma version to ^0.8.0.
// 2. Replaced intitalized with initialized and added require statement to prevent re-initialization.
// 3. Changed function names to follow camelCase naming convention.
// 4. Removed payable from collect function as it is not required.
// 5. Added require statements to check for sufficient funds and successful transfers.
// 6. Changed LastMsg struct to local variable in addMessage function to prevent overwriting of data.
// 7. Changed string data parameter to memory type.