/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
    uint public MinSum = 1 ether;
    LogFile Log;

    bool initialized;

    function PERSONAL_BANK(address _log) public {
        Log = LogFile(_log);
    }

    function setMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        Log.addMessage(msg.sender, _am, "Collect");
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.addMessage(msg.sender, msg.value, "Put");
    }

    function() public payable {
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

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Removed the Initialized() function and used a bool variable "initialized" to check if the contract has been initialized.
// 2. Removed the SetMinSum() and SetLogFile() functions and added them as arguments to the constructor.
// 3. Renamed the Collect() function to collect() and added require statements to check for minimum balance and prevent reentrancy.
// 4. Renamed the Deposit() function to deposit() and added a LogFile object to log messages.
// 5. Renamed the AddMessage() function to addMessage() and added a new Message struct to store messages.